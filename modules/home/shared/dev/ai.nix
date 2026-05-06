{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dev;

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = "openai/gpt-5.4";
    plugin = [
      "@simonwjackson/opencode-direnv"
      "@zenobius/opencode-background"
      "envsitter-guard@latest"
      "superpowers@git+https://github.com/obra/superpowers.git#v5.0.7"
    ];
    autoupdate = false;
    small_model = "openai/gpt-5.2-codex";
    mcp = {
      shadcn = {
        type = "local";
        command = [ "npx" "-y" "shadcn@latest" "mcp" ];
        enabled = true;
      };
    };
    provider = {
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "http://localhost:11434/v1";
        };
        models = {
          "gpt-oss:20b" = {
            name = "gpt-oss:20b";
            tool_call = false;
            reasoning = true;
            options = { num_ctx = 128000; };
          };
          "qwen3:8b" = {
            name = "qwen3:8b";
            tool_call = true;
            reasoning = true;
            options = { num_ctx = 40000; };
          };
          "qwen3:4b" = {
            name = "qwen3:4b";
            tool_call = true;
            reasoning = true;
            options = { num_ctx = 40000; };
          };
        };
      };
    };
  };

  opencodeConfigFile = pkgs.writeText "opencode.json" (builtins.toJSON opencodeConfig);
in
{
  config = mkIf cfg.ai.enable {
    home.file = {
      ".config/opencode/opencode.json".source = opencodeConfigFile;
      ".config/opencode/AGENTS.md".source = ../../configs/opencode/AGENTS.md;
      ".config/opencode/nixtools".source = ../../configs/opencode/nixtools;
      ".config/opencode/nixplugin".source = ../../configs/opencode/plugin;
      ".config/opencode/agent".source = ../../configs/opencode/agent;
      ".config/opencode/themes".source = ../../configs/opencode/themes;
    };

    # Bun doesn't handle dynamic import() with symlinks, so copy nixtools to tool/ and nixplugin to plugin/
    home.activation.setupOpencodeTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/.config/opencode/tool
      cp -f ~/.config/opencode/nixtools/* ~/.config/opencode/tool/
      chmod 600 ~/.config/opencode/tool/*
      
      if [ -d ~/.config/opencode/nixplugin ]; then
        cp -f ~/.config/opencode/nixplugin/* ~/.config/opencode/plugin/
        chmod 600 ~/.config/opencode/plugin/*.ts 2>/dev/null || true
      fi
    '';

    home.sessionVariables = {
      # OPENCODE_DISABLE_DEFAULT_PLUGINS = "true";
    };
    home.packages = with pkgs; [
      opencode

      # claude code currently broken
      # claude-code

      # this too the power of AI everyone
      # gemini-cli
    ];
  };
}
