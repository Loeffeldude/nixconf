{ config, lib, flake-inputs, ... }: {

  imports = [ ./dock.nix ./settings.nix flake-inputs.home-manager.darwinModules.home-manager ];
  options = {
    apps = {
      enable = lib.mkEnableOption "enable apps in home manager via flatpak";
    };
  };
  config = {
    dock = {
      enable = true;
      username = "${config.primaryUser}";
      entries = [
        {
          path = "/Users/${config.primaryUser}/Applications/Home Manager Apps/WezTerm.app";
        }
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs.flake-inputs = flake-inputs;
      extraSpecialArgs.upperConfig = config;
      users.${config.primaryUser} = import ./home.nix;
    };

  };
}
