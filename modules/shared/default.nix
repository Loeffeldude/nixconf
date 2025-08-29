{ config, pkgs, lib, ... }:

{
  imports = [
    ./ai
    ./core
    ./dev
    ./gaming
  ];
  config = { };
}
