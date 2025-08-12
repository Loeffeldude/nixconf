{ config, pkgs, lib, ... }: {
  # i manage nvim over the normal nvim dir here
  # because of lazyvi
  # some day i might migrate

  home.packages = with pkgs; [ neovim ];

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
}
