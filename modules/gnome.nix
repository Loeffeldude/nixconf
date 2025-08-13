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

        "com/raggesilver/BlackBox" = {
          font = "Recursive Mono Casual Static 11";
          terminal-bell = false;
        };

        "io/github/celluloid-player/celluloid".always-open-new-window = true;

        # Hidden/background programs only show up if they are flatpaks,
        # so disable background play for now.
        "io/bassi/Amberol".background-play = false;

        "org/gnome/settings-daemon/plugins/media-keys" = {
          screenreader = mkEmptyArray type.string;
          magnifier = mkEmptyArray type.string;
          calculator = [ "<Super>c" ];
        };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
          {
            binding = "<Super>Return";
            command = "/usr/bin/env blackbox";
            name = "Terminal";
          };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" =
          {
            binding = "<Super>e";
            command = "/usr/bin/env nautilus";
            name = "File Manager";
          };

        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" =
          {
            binding = "<Super>k";
            command = "/usr/bin/env keepassxc";
            name = "Password Manager";
          };

        "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
        ];

        "org/gnome/desktop/wm/keybindings" = {
          switch-to-workspace-left = [ "<Super>a" ];
          switch-to-workspace-right = [ "<Super>d" ];
          move-to-workspace-left = [ "<Shift><Super>a" ];
          move-to-workspace-right = [ "<Shift><Super>d" ];
          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];
          switch-input-source = [ "<Shift><Alt>" ];
          switch-input-source-backward = mkEmptyArray type.string;
          activate-window-menu = [ "Menu" ];
          close = [ "<Shift><Super>w" ];
          maximize = [ "<Super>f" ];
          toggle-fullscreen = [ "<Shift><Super>f" ];
        };

        "org/gnome/shell/keybindings" = {
          # Following binds are replaced by the ones above.
          toggle-application-view = mkEmptyArray type.string;
          switch-to-application-1 = mkEmptyArray type.string;
          switch-to-application-2 = mkEmptyArray type.string;
          switch-to-application-3 = mkEmptyArray type.string;
          switch-to-application-4 = mkEmptyArray type.string;

          show-screen-recording-ui = mkEmptyArray type.string;
          screenshot = mkEmptyArray type.string;
          show-screenshot-ui = [ "<Shift><Super>s" ];
          screenshot-window = mkEmptyArray type.string;
        };

        "org/gnome/shell".enabled-extensions = [
          "blur-my-shell@aunetx"
          "burn-my-windows@schneegans.github.com"
          "dash-to-panel@jderose9.github.com"
          "date-menu-formatter@marcinjakubowski.github.com"
          "desktop-cube@schneegans.github.com"
        ];

        "org/gnome/shell/extensions/dash-to-panel" = {
          # Even when we are not using multiple panels on multiple monitors,
          # the extension still creates them in the config, so we set the same
          # configuration for each (up to 2 monitors).
          panel-positions =
            builtins.toJSON (lib.genAttrs [ "0" "1" ] (x: "TOP"));
          panel-sizes = builtins.toJSON (lib.genAttrs [ "0" "1" ] (x: 32));
          panel-element-positions = builtins.toJSON (lib.genAttrs [ "0" "1" ]
            (x: [
              {
                element = "showAppsButton";
                visible = true;
                position = "stackedTL";
              }
              {
                element = "activitiesButton";
                visible = false;
                position = "stackedTL";
              }
              {
                element = "dateMenu";
                visible = true;
                position = "stackedTL";
              }
              {
                element = "leftBox";
                visible = true;
                position = "stackedTL";
              }
              {
                element = "taskbar";
                visible = true;
                position = "centerMonitor";
              }
              {
                element = "centerBox";
                visible = false;
                position = "centered";
              }
              {
                element = "rightBox";
                visible = true;
                position = "stackedBR";
              }
              {
                element = "systemMenu";
                visible = true;
                position = "stackedBR";
              }
              {
                element = "desktopButton";
                visible = false;
                position = "stackedBR";
              }
            ]));
          multi-monitors = false;
          show-apps-icon-file =
            "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake-white.svg";
          show-apps-icon-padding = mkInt32 4;
          focus-highlight-dominant = true;
          dot-size = mkInt32 0;
          appicon-padding = mkInt32 2;
          appicon-margin = mkInt32 0;
          trans-use-custom-opacity = true;
          trans-panel-opacity = 0.25;
          show-favorites = false;
          group-apps = false;
          isolate-workspaces = true;
          hide-overview-on-startup = true;
          stockgs-keep-dash = true;
        };
        "org/gnome/shell/extensions/blur-my-shell".color-and-noise = false;
        "org/gnome/shell/extensions/blur-my-shell/applications".blur = false;
        "org/gnome/shell/extensions/burn-my-windows".active-profile =
          "${burnMyWindowsProfile}";
        "org/gnome/shell/extensions/date-menu-formatter".pattern =
          "y-MM-dd kk:mm";
        "org/gnome/shell/extensions/desktop-cube" = {
          last-first-gap = false;
          window-parallax = 0.75;
          edge-switch-pressure = mkUint32 100;
          mouse-rotation-speed = 1.0;
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
