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
      username = "nicokratschmer";
      entries = [
        {
          path = "/Users/nicokratschmer/Applications/Home Manager Apps/WezTerm.app";
        }
        {
          path = "/Users/nicokratschmer/Applications/Home Manager Apps/Firefox.app";
        }
      ];
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
      extraSpecialArgs.flake-inputs = flake-inputs;
      users.nicokratschmer = import ./home.nix;
    };
  };
}
