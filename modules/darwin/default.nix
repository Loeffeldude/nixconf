{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [
    ../shared
    flake-inputs.mac-app-util.darwinModules.default
  ];
  config = { };
}
