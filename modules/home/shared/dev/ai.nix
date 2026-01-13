{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dev;
  opencode-anthropic-auth = pkgs.fetchFromGitHub {
    owner = "deveworld";
    repo = "opencode-anthropic-auth";
    rev = "master";
    sha256 = "sha256-+6sVYt7KQ+TBp4neNz4TdWAb2sHoCGmokkSNnQutXVI=";
  };

  opencode-patched = pkgs.opencode.overrideAttrs (oldAttrs: {
    version = "1.1.18";
    src = pkgs.fetchFromGitHub {
      owner = "anomalyco";
      repo = "opencode";
      tag = "v1.1.18";
      hash = "sha256-3A4s0FpjZuGB0HGMQVBXfWq+0yHmeIvnEQTSX3amV4I=";
    };
    node_modules = oldAttrs.node_modules.overrideAttrs {
      version = "1.1.18";
      src = pkgs.fetchFromGitHub {
        owner = "anomalyco";
        repo = "opencode";
        tag = "v1.1.18";
        hash = "sha256-3A4s0FpjZuGB0HGMQVBXfWq+0yHmeIvnEQTSX3amV4I=";
      };
      outputHash = "sha256-zSco4ORQQOqV3vMPuP+M/q/hBa+MJGnTKIlxgngMA3g=";
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
    theme = "opencode";
    model = "anthropic/claude-sonnet-4-5";
    plugin = [
      "file://${config.home.homeDirectory}/.config/opencode/plugin/opencode-anthropic-auth/index.mjs"
    ];
    small_model = "anthropic/claude-haiku-4-5";
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
    };

    # Bun doesn't handle dynamic import() with symlinks, so copy nixtools to tool/
    home.activation.setupOpencodeTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/.config/opencode/tool
      cp -f ~/.config/opencode/nixtools/* ~/.config/opencode/tool/
      chmod 600 ~/.config/opencode/tool/*
      
      rm -f ~/.config/opencode/package.json
      cp ~/.config/opencode/package.json.tmp ~/.config/opencode/package.json

      rm -rf ~/.config/opencode/plugin/opencode-anthropic-auth
      mkdir -p ~/.config/opencode/plugin/opencode-anthropic-auth
      cp -r ${opencode-anthropic-auth}/* ~/.config/opencode/plugin/opencode-anthropic-auth/
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
