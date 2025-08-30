{ config, pkgs, lib, ... }:

{
  imports = [
    ./core
    ./dev
    ./gaming
  ];
  config = { };
}
