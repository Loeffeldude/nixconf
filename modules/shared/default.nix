{ config, pkgs, lib, ... }:

{
  imports = [
    ./core
    ./dev
    ./gaming
    ./insecure.nix
    # ./networking
  ];
  config = { };
}
