{ config, pkgs, lib, ... }: {
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "de";
        variant = "";
        options = "caps:escape"; # I use caps as escaping edit mode in vim
      };

      # Enable GNOME Display Manager
      displayManager.gdm.enable = true;

      # Enable GNOME Desktop Environment
      desktopManager.gnome.enable = true;
    };

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
  environment.systemPackages = with pkgs; [ gnomeExtensions.appindicator ];
  programs.dconf.enable = true;
  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
    gnome.adwaita-icon-theme
  ];
  # Font configuration
  fonts.packages = with pkgs;
    [
      # noto-fonts
      # noto-fonts-cjk
      # noto-fonts-emoji
      # liberation_ttf
      # fira-code
      # fira-code-symbols
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
