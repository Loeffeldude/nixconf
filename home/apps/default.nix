{ config, pkgs, flake-inputs, lib, ... }: {
  imports = [
    flake-inputs.nix-flatpak.homeManagerModules.nix-flatpak
    ./dev.nix
    ./gaming.nix
    ./media.nix
    ./misc.nix
    ./productivity.nix
    ./social.nix
  ];
  # This prevents flatpak-install taking longer from not being able to be applied 
  systemd.user.services."home-manager-loeffel".serviceConfig.TimeoutStartSec =
    lib.mkForce "600";

  # Configure nix-flatpak
  services.flatpak = { enable = true; };
  services.flatpak.update.onActivation = true;

  home.packages = with pkgs; [ protonvpn-gui ];
}
