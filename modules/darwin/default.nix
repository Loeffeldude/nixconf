{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [
    ../shared
    ./karabiner.nix
    ./homebrew.nix
    flake-inputs.mac-app-util.darwinModules.default
  ];
  config = { };
}
