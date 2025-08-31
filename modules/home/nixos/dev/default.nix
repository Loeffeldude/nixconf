{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
    ./gamedev
    ./utilities.nix
    ./neovim.nix
    ./zsh.nix
  ];
}
