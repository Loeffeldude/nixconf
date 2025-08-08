{ config, pkgs, ... }: {
  services = {
    xserver = {
      enable = true;
      displayManager.sddm = {
        enable = true;
        theme = "breeze";
        settings = {
          Theme = {
            CursorTheme = "breeze_cursors";
            Font = "Inter";
          };
        };
      };

      desktopManager.plasma6 = {
        enable = true;
        extraPackages = with pkgs.kdePackages; [ ];
      };

      # Keyboard settings
      xkb = {
        layout = "de";
        variant = "";
        options = "caps:escape"; # I use caps as escaping edit mode in vim
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
  };

  # explicitly disable kde-connect
  programs.kdeconnect.enable = false;

  environment.systemPackages = with pkgs; [
    # Themes
    libsForQt5.qtstyleplugin-kvantum
    breeze-icons
    breeze-qt5
    breeze-gtk

    # Applications
    kdePackages.yakuake # Drop-down terminal
    kdePackages.krunner
    kdePackages.plasma-browser-integration
    kdePackages.bismuth # Tiling window manager for KDE

    # System tools
    kdePackages.kde-gtk-config
    kdePackages.kinfocenter
    kdePackages.ksystemlog

    # Multimedia
    kdePackages.kmix
    kdePackages.k3b
  ];

  # Font configuration
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
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
    "x-scheme-handler/mailto" = "org.kde.kmail2.desktop";
  };

  qt = {
    enable = true;
    platformTheme = "kde";
    style = "breeze";
  };

  programs.partition-manager.enable = true;
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
