{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ wezterm nerd-fonts.jetbrains-mono ];
    fonts.fontconfig.enable = true;

    home.file.".config/wezterm" = {
      source = ../../configs/wezterm;
      recursive = true;
    };

    home.sessionVariables = { TERM = "wezterm"; };

  };
}
