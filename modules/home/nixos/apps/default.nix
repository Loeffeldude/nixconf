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
<<<<<<< HEAD
    systemd.user.services."home-manager-nicokratschmer".serviceConfig.TimeoutStartSec =
=======
    systemd.user.services."home-manager-${config.primaryUser}".serviceConfig.TimeoutStartSec =
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756
      lib.mkForce "600";

    # Configure nix-flatpak
    services.flatpak = { enable = lib.mkForce true; };

  };
}
