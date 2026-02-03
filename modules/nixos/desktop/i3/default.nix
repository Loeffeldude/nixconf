# EXPERIMENTAL: Standalone i3 window manager module
# Currently not in use - main setup uses Hyprland
# Kept for future reference/testing
{ config, pkgs, lib, ... }:
with lib;

let cfg = config.desktop.i3;
in {

  options.desktop.i3 = { enable = mkEnableOption "enable i3"; };

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
            i3blocks
          ];
        };
      };

      displayManager.defaultSession = "none+i3";

      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
          middleEmulation = true;
          accelProfile = "adaptive";
        };
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

    # XDG portals for file dialogs and screen sharing
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };

    xdg.icons.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
    };

    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    services.printing = {
      enable = true;
      drivers = [ pkgs.hplip ];
    };
    
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.displayManager.sddm = {
      enable = true;
      theme = "breeze";
    };

    environment.systemPackages = with pkgs; [
      feh
      scrot
      dunst
      libnotify
      playerctl
      rofi
      picom
      arandr
      networkmanagerapplet
      pavucontrol
      blueman
    ];

    home-manager.users.${config.primaryUser} = { desktop.i3.enable = true; };
  };
}
