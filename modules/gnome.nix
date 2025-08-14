{ config, pkgs, lib, ... }: {
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

  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];

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
}
