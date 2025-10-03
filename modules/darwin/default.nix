{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [
    ../shared
    ./karabiner.nix
    flake-inputs.mac-app-util.darwinModules.default
  ];
  config = { };
}
