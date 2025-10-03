{ config, pkgs, lib, ... }:
with lib;

let cfg = config.desktop.kde;
in {

  options.desktop.kde = { enable = mkEnableOption "enable gnome"; };

  config = mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;

      displayManager.sddm.enable = true;

      displayManager.sddm.wayland.enable = true;
    };

    # Sound
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Power management
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Network Manager
    networking.networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    # home-manager.users.nicokratschmer = { desktop..enable = true; };
  };
}

