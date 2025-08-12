{ config, pkgs, ... }: {
  home.packages = with pkgs; [ wezterm nerd-fonts.jetbrains-mono ];

  home.file.".config/wezterm" = {
    source = ./wezterm;
    recursive = true;
  };

}
