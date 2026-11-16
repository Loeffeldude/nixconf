{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.productivity.enable {
    home.packages = with pkgs; [ thunderbird obsidian ];

    programs.firefox = {
      enable = true;
      configPath = ".mozilla/firefox";
      package =
        if pkgs.stdenv.isDarwin
        then null
        else pkgs.firefox; # Standard für Linux/NixOS
    };

    home.file."Library/Application Support/Firefox" = mkIf pkgs.stdenv.isDarwin {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.mozilla/firefox";
    };
  };
}
