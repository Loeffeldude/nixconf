{ config, lib, pkgs, ... }:

with lib;
let cfg = config.dev;
in {
  config = mkIf cfg.ai.enable {
    home.packages = with pkgs; [ opencode claude-code gemini-cli ];
  };
}
