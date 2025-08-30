{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared
    ./ai
    ./dev
    ./core
    ./desktop
    ./gaming
    ./virtualization
    ./nvidia.nix
  ];
  config = { };
}
