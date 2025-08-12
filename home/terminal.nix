{ config, pkgs, ... }: {
  home.packages = with pkgs; [ wezterm nerd-fonts.jetbrains-mono ];
  fonts.fontconfig.enable = true;
  home.file.".config/wezterm" = {
    source = ./wezterm;
    recursive = true;
  };

}
