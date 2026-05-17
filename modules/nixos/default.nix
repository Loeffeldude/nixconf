{ config, pkgs, lib, flake-inputs, ... }:

{
  imports = [
    ../shared
    ./amd.nix
    ./ai
    ./dev
    ./core
    ./desktop
    ./gaming
    ./virtualization
    ./nvidia.nix
    # ./sops
  ];
  config = { };
}
