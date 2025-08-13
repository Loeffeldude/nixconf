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

  environment.systemPackages = with pkgs; [ ];
  programs.dconf.profiles = {
    # TODO: Investigate customizing gdm greeter.
    user.databases = [{
      settings = with lib.gvariant; {
        "org/gnome/desktop/calendar".show-weekdate = true;
        "org/gnome/desktop/input-sources".sources =
          [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "lt" ]) ];
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        "org/gnome/desktop/interface".show-battery-percentage = true;
        "org/gnome/desktop/media-handling".automount = false;
        "org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
        "org/gnome/desktop/privacy".remember-recent-files = false;
        "org/gnome/desktop/screensaver".lock-enabled = false;
        "org/gnome/desktop/session".idle-delay = mkUint32 0;
        "org/gnome/desktop/wm/preferences".resize-with-right-button = true;
        "org/gnome/mutter" = {
          edge-tiling = true;
          attach-modal-dialogs = true;
          experimental-features = [ "scale-monitor-framebuffer" ];
        };
        "org/gnome/settings-daemon/plugins/power" = {
          # Suspend only on battery power, not while charging.
          sleep-inactive-ac-type = "nothing";
          power-button-action = "interactive";
        };

        "org/gnome/nautilus/preferences".default-folder-viewer = "list-view";
        "org/gnome/nautilus/list-view" = {
          use-tree-view = true;
          default-zoom-level = "small";
        };

        "org/gtk/gtk4/settings/file-chooser" = {
          sort-directories-first = true;
          show-hidden = true;
          view-type = "list";
        };
      };
    }];

  };
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
