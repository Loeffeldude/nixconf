{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.apps;

in {
  imports = [
    ./media.nix
  ];
  config = mkIf cfg.enable { };
}
