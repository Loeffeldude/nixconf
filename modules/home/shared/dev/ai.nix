{ config, lib, pkgs, flake-inputs, ... }:

with lib;
let
  cfg = config.dev;

  opencodeConfig = {
    "$schema" = "https://opencode.ai/config.json";
    model = "openai/gpt-5.6-terra";
    plugin = [
      # "@simonwjackson/opencode-direnv"
      # "@zenobius/opencode-background"
      "envsitter-guard@latest"
      # "@dietrichgebert/ponytail"
      # "superpowers@git+https://github.com/obra/superpowers.git#v5.0.7"
    ];
    autoupdate = false;
    small_model = "openai/gpt-5.6-luna";
    mcp = {
      ghidra = {
        type = "local";
        command = [ "bridge_mcp_ghidra" "--ghidra-server" "http://127.0.0.1:8082/" ];
        enabled = false;
      };
      shadcn = {
        type = "local";
        command = [ "npx" "-y" "shadcn@latest" "mcp" ];
        enabled = false;
      };
    };
    agent =
      {
        build = {
          mode = "primary";
          model = "openai/gpt-6-astra";
          prompt = "{file:./prompts/build.md}";
          permission = {
            edit = "allow";
            bash = "allow";
          };
        };
        plan = {
          mode = "primary";
          model = "openai/gpt-5.6-sol";
        };
        general = {
          mode = "subagent";
          model = "openai/gpt-5.6-terra";
        };
        explore = {
          mode = "subagent";
          model = "openai/gpt-5.6-luna";
        };
      };
    provider = { };
  };

  opencodeConfigFile = pkgs.writeText "opencode.json" (builtins.toJSON (lib.recursiveUpdate opencodeConfig cfg.ai.opencodeOverrides));
  opencode = flake-inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  options.dev.ai.opencodeOverrides = mkOption {
    type = (pkgs.formats.json { }).type;
    default = { };
    description = "Host-specific overrides for the shared OpenCode configuration.";
  };

  config = mkIf cfg.ai.enable {
    home.file = {
      ".config/opencode/opencode.json".source = opencodeConfigFile;
      ".config/opencode/AGENTS.md".source = ../../configs/opencode/AGENTS.md;
      ".config/opencode/prompts/build.md".source = ../../configs/opencode/prompts/build.md;
      # ".config/opencode/nixtools".source = ../../configs/opencode/nixtools;
      # ".config/opencode/nixplugin".source = ../../configs/opencode/plugin;
      # ".config/opencode/agent".source = ../../configs/opencode/agent;
      ".config/opencode/themes".source = ../../configs/opencode/themes;
      # ".config/opencode/skills".source = ../../configs/opencode/skills;
    };

    # Bun doesn't handle dynamic import() with symlinks, so copy nixtools to tool/ and nixplugin to plugin/
    home.activation.setupOpencodeTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/.config/opencode/tool
      # cp -f ~/.config/opencode/nixtools/* ~/.config/opencode/tool/
      # chmod 600 ~/.config/opencode/tool/*
      
      if [ -d ~/.config/opencode/nixplugin ]; then
        cp -f ~/.config/opencode/nixplugin/* ~/.config/opencode/plugin/
        chmod 600 ~/.config/opencode/plugin/*.ts 2>/dev/null || true
      fi
    '';

    home.sessionVariables = {
      # OPENCODE_DISABLE_DEFAULT_PLUGINS = "true";
    };
    home.packages = with pkgs; [
      pi-coding-agent
      pkgs.opencode
      # broken atm wating for flake to include codesign util 
      # (opencode.override {
      #   node_modules = opencode.node_modules.override { hash = "sha256-9JDPylBvKDqH0qn+iTJZ5GF3CXtj0vgyRewzLMIE/nw="; };
      # })

      # claude code currently broken
      # claude-code

      # this too the power of AI everyone
      # gemini-cli
    ];
  };
}
