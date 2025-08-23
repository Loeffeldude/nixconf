{ config, pkgs, lib, ... }:
with lib;

let cfg = config.desktop.gnome;
in {

  options.desktop.gnome = { enable = mkEnableOption "enable gnome"; };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = "de";
          variant = "";
          options = "caps:escape"; # I use caps as escaping edit mode in vim
        };

      };
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;

      # Touchpad settings
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
    programs.dconf.enable = true;

    environment.systemPackages = with pkgs; [
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.native-window-placement
      gnomeExtensions.screenshot-tool
      gnomeExtensions.window-list
      gnomeExtensions.applications-menu
      gnomeExtensions.gsconnect # KDE Connect implementation
      gnomeExtensions.blur-my-shell # Adds blur effects
      gnomeExtensions.vitals # System monitoring
      gnomeExtensions.workspace-indicator # Shows workspace number
      gnomeExtensions.sound-output-device-chooser # Audio output switcher
      gnomeExtensions.clipboard-indicator # Clipboard manager
      gnomeExtensions.openweather-refined
    ];

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
      adwaita-icon-theme
    ];

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
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      configPackages = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
    };
    # Network Manager
    networking.networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    xdg.icons.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/mailto" = "org.gnome.evolution.desktop";
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

    home-manager.users.loeffel = { desktop.gnome.enable = true; };
  };
}

