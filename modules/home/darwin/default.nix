{ config, lib, flake-inputs, ... }: {

  imports = [ ./dock.nix flake-inputs.home-manager.darwinModules.home-manager ];
  options = {
    apps = {
      enable = lib.mkEnableOption "enable apps in home manager via flatpak";
    };
  };
  config = {
    dock = {
      enable = true;
      username = "loeffel";
      entries = [
        {
          path = "/Applications/Home Manager Apps/WezTerm.app";
        }
        {
          path = "/Applications/Home Manager Apps/Firefox.app";
        }
        {
          path = "/Applications/Home Manager Apps/Firefox.app";
        }
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs.flake-inputs = flake-inputs;
      users.loeffel = import ./home.nix;
    };
  };
}
