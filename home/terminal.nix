{ config, pkgs, ... }: {
  home.packages = with pkgs; [ wezterm ];

  home.file.".wezterm" = {
    source = ./wezterm;
    recursive = true;
  };

}
