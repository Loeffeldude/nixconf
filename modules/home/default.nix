{ config, lib, flake-inputs, ... }: {

  imports = [ flake-inputs.home-manager.nixosModules.home-manager ];
  options = {
    apps = {
      enable = lib.mkEnableOption "enable apps in home manager via flatpak";
    };
  };
  config = {

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs.flake-inputs = flake-inputs;
      users.loeffel = {
        imports =
          [ ./apps/default.nix ./desktop/default.nix ./dev/default.nix ];

        home.username = "loeffel";
        home.homeDirectory = lib.mkForce "/home/loeffel";

        apps.enable = lib.mkForce config.apps.enable;

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
    };
  };
}
