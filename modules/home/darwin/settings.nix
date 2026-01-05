{ config, pkgs, ... }: {
  # Settings for making MacOS berable
  #
  # TODO: I should probably split this up like I did in NixOS
  #
  system.primaryUser = "${config.primaryUser}";


  system.defaults = {
    NSGlobalDomain."com.apple.swipescrolldirection" = false;
    dock = {
      launchanim = false;
      mineffect = "scale";
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

  services.aerospace.enable = false;
  services.aerospace.settings =
    let
      wezterm = pkgs.wezterm;
    in
    {
      enable-normalization-flatten-containers = false;
      enable-normalization-opposite-orientation-for-nested-containers = false;
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];

      mode.main.binding = {
        alt-enter = ''exec-and-forget ${wezterm}/bin/wezterm start'';

        alt-j = "focus --boundaries-action wrap-around-the-workspace left";
        alt-k = "focus --boundaries-action wrap-around-the-workspace down";
        alt-l = "focus --boundaries-action wrap-around-the-workspace up";
        # "alt-ö" = "focus --boundaries-action wrap-around-the-workspace right";

        alt-shift-j = "move left";
        alt-shift-k = "move down";
        alt-shift-l = "move up";
        # "alt-shift-ö" = "move right";

        alt-h = "split horizontal";
        alt-v = "split vertical";

        alt-f = "fullscreen";
        alt-s = "layout v_accordion";
        alt-w = "layout h_accordion";
        alt-e = "layout tiles horizontal vertical";

        alt-shift-space = "layout floating tiling";

        ctrl-1 = "workspace 1";
        ctrl-2 = "workspace 2";
        ctrl-3 = "workspace 3";
        ctrl-4 = "workspace 4";
        ctrl-5 = "workspace 5";
        ctrl-6 = "workspace 6";
        ctrl-7 = "workspace 7";
        ctrl-8 = "workspace 8";
        ctrl-9 = "workspace 9";
        ctrl-0 = "workspace 10";

        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";
        alt-shift-0 = "move-node-to-workspace 10";

        alt-shift-c = "reload-config";

        alt-r = "mode resize";
      };

      workspace-to-monitor-force-assignment = {
        "1" = 1;
        "2" = 1;
        "3" = 2;
        "4" = 2;
        "5" = 3;
        "6" = 3;
      };

      mode.resize.binding = {
        h = "resize width -50";
        j = "resize height +50";
        k = "resize height -50";
        l = "resize width +50";
        enter = "mode main";
        esc = "mode main";
      };
    };

  # User settings
  home-manager.users.${config.primaryUser} = {
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
