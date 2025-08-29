{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.apps;
in {

  imports = [
    ./options.nix
    ./dev.nix
    ./gaming.nix
    ./media.nix
    ./misc.nix
    ./productivity.nix
    ./social.nix
  ];

  config = mkIf cfg.enable { };
}
