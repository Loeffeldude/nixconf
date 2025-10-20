{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.productivity.enable {
    home.packages = with pkgs; [ thunderbird obsidian ];

    programs.firefox = {
      enable = true;
    };
  };
}
