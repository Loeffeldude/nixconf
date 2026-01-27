{ config, pkgs, ... }: {
  # Settings for making MacOS berable
  #
  # TODO: I should probably split this up like I did in NixOS
  #
  system.primaryUser = "${config.primaryUser}";


  system.defaults = {
    NSGlobalDomain = {
      "com.apple.swipescrolldirection" = false;
      _HIHideMenuBar = true;
    };
    dock = {
      launchanim = false;
      mineffect = "scale";
      autohide = true;
    };
  };
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;
  # Swaps Command and CTRL
  # I am not relearning my muscle memory
  system.keyboard.userKeyMapping = [
    # {
    #   HIDKeyboardModifierMappingSrc = 30064771296;
    #   HIDKeyboardModifierMappingDst = 30064771299;
    # }
    # {
    #   HIDKeyboardModifierMappingSrc = 30064771299;
    #   HIDKeyboardModifierMappingDst = 30064771296;
    #
    # }
  ];

  services.aerospace.enable = true;
  services.aerospace.settings =
    let
      wezterm = pkgs.wezterm;
    in
    {
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";

      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
      automatically-unhide-macos-hidden-apps = false;

      after-startup-command = [ "exec-and-forget sketchybar" ];

      exec-on-workspace-change = [
        "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
      ];

      gaps = {
        inner.horizontal = 10;
        inner.vertical = 10;
        outer.left = 10;
        outer.bottom = 34;
        outer.top = 42;
        outer.right = 10;
      };

      mode.main.binding = {
        cmd-enter = ''exec-and-forget ${wezterm}/bin/wezterm start'';

        # Layout switching
        cmd-shift-comma = "layout tiles horizontal vertical";
        cmd-shift-period = "layout accordion horizontal vertical";

        # Focus (QWERTY hjkl) - using cmd to avoid conflict with neovim
        cmd-h = "focus left";
        cmd-j = "focus down";
        cmd-k = "focus up";
        cmd-l = "focus right";

        # Move windows
        cmd-shift-h = "move left";
        cmd-shift-j = "move down";
        cmd-shift-k = "move up";
        cmd-shift-l = "move right";

        # Move windows to monitors
        ctrl-cmd-h = "move-node-to-monitor left";
        ctrl-cmd-l = "move-node-to-monitor right";

        # Resize
        ctrl-cmd-k = "resize smart -50";
        ctrl-cmd-j = "resize smart +50";

        # Workspace switching
        ctrl-cmd-1 = "workspace 1";
        ctrl-cmd-2 = "workspace 2";
        ctrl-cmd-3 = "workspace 3";
        ctrl-cmd-4 = "workspace 4";
        ctrl-cmd-5 = "workspace 5";
        ctrl-cmd-6 = "workspace 6";
        ctrl-cmd-7 = "workspace 7";
        ctrl-cmd-8 = "workspace 8";
        ctrl-cmd-9 = "workspace 9";

        # Move to workspace
        ctrl-cmd-shift-1 = "move-node-to-workspace 1";
        ctrl-cmd-shift-2 = "move-node-to-workspace 2";
        ctrl-cmd-shift-3 = "move-node-to-workspace 3";
        ctrl-cmd-shift-4 = "move-node-to-workspace 4";
        ctrl-cmd-shift-5 = "move-node-to-workspace 5";
        ctrl-cmd-shift-6 = "move-node-to-workspace 6";
        ctrl-cmd-shift-7 = "move-node-to-workspace 7";
        ctrl-cmd-shift-8 = "move-node-to-workspace 8";
        ctrl-cmd-shift-9 = "move-node-to-workspace 9";

        # Fullscreen and other utilities
        ctrl-cmd-space = "fullscreen";
        ctrl-cmd-tab = "workspace-back-and-forth";
        ctrl-cmd-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # Enter service mode
        ctrl-cmd-s = "mode service";
      };

      workspace-to-monitor-force-assignment = {
        "1" = 1;
        "2" = 1;
        "3" = 2;
        "4" = 2;
        "5" = 3;
        "6" = 3;
      };

      mode.service.binding = {
        esc = [ "reload-config" "mode main" ];
        r = [ "flatten-workspace-tree" "mode main" ];
        f = [ "layout floating tiling" "mode main" ];
        backspace = [ "close-all-windows-but-current" "mode main" ];

        cmd-shift-h = [ "join-with left" "mode main" ];
        cmd-shift-j = [ "join-with down" "mode main" ];
        cmd-shift-k = [ "join-with up" "mode main" ];
        cmd-shift-l = [ "join-with right" "mode main" ];
      };
    };

  # User settings
  home-manager.users.${config.primaryUser} = {
    home.packages = with pkgs; [
      sbarlua
    ];

    programs.sketchybar = {
      enable = true;
      config = {
        source = ../configs/sketchybar;
        recursive = true;
      };
    };

    targets.darwin.defaults = {
      "com.apple.menuextra.clock".Show24Hour = true;
      NSGlobalDomain = {
        # Localization
        AppleLanguages = [ "en" ];
        AppleLocale = "en_US";
        AppleMeasurementUnits = "Centimeters";
        AppleTemperatureUnit = "Celsius";
        AppleMetricUnits = true;

        # General Settings
        ApplePressAndHoldEnabled = true;
        AppleShowAllExtensions = true;
        # Writing / Typing
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        # Can't spell for shit
        NSAutomaticSpellingCorrectionEnabled = true;

        # Not to sure about this one... really depends on the network store
        # "com.apple.desktopservices".DSDontWriteNetworkStores = false;
        "com.apple.desktopservices".DSDontWriteUSBStores = true;

        # Dock
        "com.apple.dock" = {
          autohide = false;
          orientation = "bottom";
          size-immutable = true;
          tilesize = 36;
        };
        # Finder
        "com.apple.finder" = {
          AppleShowAllFiles = true;
          ShowPathBar = true;
          ShowStatusBar = true;
        };

        targets.darwin.search = "Google";
      };
    };
  };
}
