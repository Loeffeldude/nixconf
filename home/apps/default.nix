{ config, pkgs, flake-inputs, lib, ... }: {
  imports = [
    # Import the nix-flatpak NixOS module and install applications system wide.
    # HomeManager users should import `${nix-flatpak}/modules/home-manager.nix`
    # where appropriate
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
  services.flatpak = {
    enable = true;
    packages = [ "org.mozilla.firefox" ];
  };

  home.packages = with pkgs; [ protonvpn-gui ];
}
