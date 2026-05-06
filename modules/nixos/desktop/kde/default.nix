{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.desktop.kde;
in
{
  options.desktop.kde = {
    enable = mkEnableOption "enable kde with i3";
  };

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
            i3lock
            i3status
          ];
        };
      };

      desktopManager.plasma6.enable = true;
      displayManager.defaultSession = "plasmax11";

      displayManager.sddm = {
        enable = true;
        wayland.enable = false;
      };

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          middleEmulation = true;
          accelProfile = "adaptive";
        };
      };

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      power-profiles-daemon.enable = true;
      upower.enable = true;
    };

    security.rtkit.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    networking.networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    environment.systemPackages = with pkgs; [
      feh
      picom
      wmctrl
      xclip
      xorg.xprop
      xorg.xwininfo
      networkmanagerapplet
      blueman
      pavucontrol
      kdePackages.spectacle
      playerctl
    ];

    home-manager.users.${config.primaryUser} = {
      desktop.kde.enable = true;
    };
  };
}
