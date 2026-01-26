{ config, pkgs, lib, ... }:
with lib;

let cfg = config.desktop.hyprland;
in {

  options.desktop.hyprland = { enable = mkEnableOption "enable hyprland"; };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
          options = "caps:escape";
        };
      };
      displayManager.gdm = {
        enable = true;
        wayland = true;
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
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
    };

    networking.networkmanager = {
      enable = true;
      wifi.powersave = true;
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

    environment.systemPackages = with pkgs; [
      wl-clipboard
      grim
      slurp
      hyprpaper
      dunst
      libnotify
      playerctl
    ];

    home-manager.users.${config.primaryUser} = { desktop.hyprland.enable = true; };
  };
}
