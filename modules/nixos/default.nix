{ config, pkgs, lib, flake-inputs, ... }:

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
    # ./sops
  ];
  config = { };
}
