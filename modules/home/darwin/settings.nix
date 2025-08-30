{ pkgs, ... }: {
  # Settings for making MacOS berable
  #
  # TODO: I should probably split this up like I did in NixOS
  #
  system.primaryUser = "loeffel";


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
    {
      HIDKeyboardModifierMappingSrc = 30064771296;
      HIDKeyboardModifierMappingDst = 30064771299;
    }
    {
      HIDKeyboardModifierMappingSrc = 30064771299;
      HIDKeyboardModifierMappingDst = 30064771296;

    }
  ];
  services.aerospace.enable = true;

  # User settings
  home-manager.users.loeffel = {
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
