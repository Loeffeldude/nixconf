import { type Plugin, tool } from "@opencode-ai/plugin";
import { existsSync } from "fs";
import { join } from "path";

interface Recipe {
  name: string;
  doc: string;
}

async function parseJustRecipes(
  $: any,
  justfilePath: string,
): Promise<Recipe[]> {
  const result =
    await $`just --justfile ${justfilePath} --list --list-heading ${" "} --list-prefix ${" "}`.text();
  const lines = result.trim().split("\n");
  const recipes: Recipe[] = [];

  for (const line of lines) {
    if (!line.trim()) continue;

    const match = line.match(/^\s*(\S+)\s*#?\s*(.*)$/);
    if (match) {
      recipes.push({
        name: match[1],
        doc: match[2] || "No description",
      });
    }
  }

  return recipes;
}

export const JustfilePlugin: Plugin = async ({
  project,
  client,
  $,
  directory,
  worktree,
}) => {
  const justfilePath = join(worktree || directory, "justfile");
  const hasJustfile =
    existsSync(justfilePath) ||
    existsSync(join(worktree || directory, "Justfile"));

  if (!hasJustfile) {
    return {};
  }

  let recipes: Recipe[] = [];
  try {
    recipes = await parseJustRecipes($, justfilePath);
  } catch (error) {
    console.log({
      service: "justfile-plugin",
      level: "warn",
      message: "Failed to parse justfile recipes",
      extra: { error: String(error) },
    });
  }

  return {
    "tui.prompt.append": async (input, output) => {
      if (recipes.length === 0) return;

      const recipeList = recipes.map((r) => `  ${r.name}: ${r.doc}`).join("\n");

      output.context.push(`
# Available Just Recipes

This project uses a Justfile for task automation. The following recipes are available:

${recipeList}

You can use them using the bash tool and \`just\`
`);
    },

    tool: {
      JustList: tool({
        description:
          "List all available recipes from the project's Justfile with their descriptions",
        args: {},
        async execute(args, ctx) {
          const recipes = await parseJustRecipes($, justfilePath);

          if (recipes.length === 0) {
            return "No recipes found in justfile";
          }

          return recipes
            .map((r) => `${r.name.padEnd(20)} # ${r.doc}`)
            .join("\n");
        },
      }),
    },
  };
};
