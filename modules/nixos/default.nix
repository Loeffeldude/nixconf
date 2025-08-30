{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared
    ./ai
    ./core
    ./desktop
    ./gaming
    ./virtualization
    ./nvidia.nix
  ];
  config = { };
}
