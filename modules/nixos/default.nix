{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared
    ./core
    ./desktop
    ./gaming
    ./virtualization
    ./nvidia.nix
  ];
  config = { };
}
