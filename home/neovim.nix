{ config, pkgs, lib, ... }: {
  # i manage nvim over the normal nvim dir here
  # because of lazyvi
  # some day i might migrate

  home.packages = with pkgs; [
    neovim
    wget
    fd
    luarocks-nix
    imagemagick
    ripgrep
    # latex
    zathura
    biber
    # for lazy packages
    nodejs_latest
  ];

  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
  };
  home.sessionVariables = { EDITOR = "nvim"; };
}
