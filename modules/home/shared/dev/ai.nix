{ config, lib, pkgs, ... }:

with lib;
let cfg = config.dev;
in {
  config = mkIf cfg.ai.enable {
    # 
    home.file.".config/opencode" = {
      source = ../../configs/opencode;
      recursive = true;
      force = true;
    };
    # Bun doesn't handle dynamic import() with symlinks, so copy nixtools to tool/
    home.activation.setupOpencodeTools = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p ~/.config/opencode/tool
      cp ~/.config/opencode/nixtools/* ~/.config/opencode/tool/
      chmod 600 ~/.config/opencode/tool/*
    '';
    home.packages = with pkgs; [
      opencode
      claude-code
      # gemini-cli 
    ];
  };
}
