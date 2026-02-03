{ config, pkgs, lib, ... }:
with lib;

let cfg = config.desktop.kde;
in {

  options.desktop.kde = { enable = mkEnableOption "enable kde with i3"; };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
          options = "caps:escape";
        };
        
        windowManager.i3 = {
          enable = true;
          extraPackages = with pkgs; [
            dmenu
            i3status
            i3lock
          ];
        };
      };

      desktopManager.plasma6.enable = true;

      displayManager.sddm = {
        enable = true;
        wayland.enable = false;
      };
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

    environment.systemPackages = with pkgs; [
      feh
      xclip
    ];

    home-manager.users.${config.primaryUser} = { desktop.kde.enable = true; };
  };
}

