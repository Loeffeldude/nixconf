{ config, upperConfig, lib, ... }: {

  imports = [
    ../shared
    ./apps
    ./desktop
    ./dev
    ./utlities.nix
  ];
  options = {
    primaryUser = lib.mkOption {
      type = lib.types.str;
      description = "Primary username for the system";
      default = upperConfig.primaryUser;
    };
  };
  config = {
    home.username = "${config.primaryUser}";
    home.homeDirectory = lib.mkForce "/home/${config.primaryUser}";

<<<<<<< HEAD
  home.username = "nicokratschmer";
  home.homeDirectory = lib.mkForce "/home/nicokratschmer";

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
=======
    # This value determines the home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.05";
  };
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756
}

