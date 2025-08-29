{ config, pkgs, lib, ... }:

{
  imports = [
    ../shared
    ./core
    ./desktop
    ./virtualization
    ./nvidia.nix
  ];
  config = { };
}
