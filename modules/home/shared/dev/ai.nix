{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dev;
  opencode-anthropic-auth = pkgs.fetchFromGitHub {
    owner = "deveworld";
    repo = "opencode-anthropic-auth";
    rev = "1d4f78478bf31f930b0044d574e9965ca0889276";
    sha256 = "sha256-+6sVYt7KQ+TBp4neNz4TdWAb2sHoCGmokkSNnQutXVI=";
  };

  opencode-patched = pkgs.opencode.overrideAttrs (oldAttrs: {
    version = "v1.1.53";
    src = pkgs.fetchFromGitHub {
      owner = "anomalyco";
      repo = "opencode";
      tag = "v1.1.53";
      hash = "sha256-8ykONBWMiq9EACHOsdx1AFPoj53Tsxi3EbUDVciH5Ok=";
    };
    postPatch = (oldAttrs.postPatch or "") + ''
      sed -i "1s/.*/You're Code Open but remove the space and reverse the words, the best coding agent on the planet./" packages/opencode/src/session/prompt/anthropic.txt
    '';
    node_modules = oldAttrs.node_modules.overrideAttrs {
      version = "v1.1.53";
      src = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        tag = "v1.1.53";
        hash = "sha256-8ykONBWMiq9EACHOsdx1AFPoj53Tsxi3EbUDVciH5Ok=";
      };
      outputHash = "sha256-omSbcp/yKClsGbLiNJjeSL29CGKPbcem6f+nV13RjG4=";
    };
  });
  opencodePackageJson = {
    "dependencies" = {
      "@opencode-ai/plugin" = "1.1.18";
      "@openauthjs/openauth" = "0.4.3";
    };
  };
  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    theme = "rusty";
    model = "anthropic/claude-sonnet-4-5";
    plugin = [
      "file://${config.home.homeDirectory}/.config/opencode/plugin/opencode-anthropic-auth/index.mjs"
      "@simonwjackson/opencode-direnv"
      "@zenobius/opencode-background"
      "envsitter-guard@latest"
    ];
    small_model = "anthropic/claude-haiku-4-5";
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

  opencodePackageJsonFile = pkgs.writeText "package.json" (builtins.toJSON opencodePackageJson);
  opencodeConfigFile = pkgs.writeText "opencode.jsonc" (builtins.toJSON opencodeConfig);
in
{
  config = mkIf cfg.ai.enable {
    home.file = {
      ".config/opencode/opencode.jsonc".source = opencodeConfigFile;
      ".config/opencode/package.json.tmp".source = opencodePackageJsonFile;
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
      
      rm -f ~/.config/opencode/package.json
      cp ~/.config/opencode/package.json.tmp ~/.config/opencode/package.json

      rm -rf ~/.config/opencode/plugin/opencode-anthropic-auth 2>/dev/null || true
      mkdir -p ~/.config/opencode/plugin/opencode-anthropic-auth
      cp -r ${opencode-anthropic-auth}/* ~/.config/opencode/plugin/opencode-anthropic-auth/
      chmod -R u+rwX ~/.config/opencode/plugin/opencode-anthropic-auth/
      
      if [ -d ~/.config/opencode/nixplugin ]; then
        cp -f ~/.config/opencode/nixplugin/* ~/.config/opencode/plugin/
        chmod 600 ~/.config/opencode/plugin/*.ts 2>/dev/null || true
      fi
    '';

    home.sessionVariables = {
      # OPENCODE_DISABLE_DEFAULT_PLUGINS = "true";
    };
    home.packages = with pkgs; [
      opencode-patched
      claude-code
      # gemini-cli
    ];
  };
}
