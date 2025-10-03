{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.apps;

in {
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./dev.nix
    ./gaming.nix
    ./media.nix
    ./misc.nix
    ./productivity.nix
    ./social.nix
  ];
  config = mkIf cfg.enable {
    # This prevents flatpak-install taking longer from not being able to be applied 
    systemd.user.services."home-manager-nicokratschmer".serviceConfig.TimeoutStartSec =
      lib.mkForce "600";

    # Configure nix-flatpak
    services.flatpak = { enable = lib.mkForce true; };

  };
}
