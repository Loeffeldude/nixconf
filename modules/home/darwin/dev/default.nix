{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
    ./zsh.nix
  ];
}
