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
      backupFileExtension = "hm-backup";
      sharedModules = [ flake-inputs.sops-nix.homeManagerModules.sops ];
      extraSpecialArgs.flake-inputs = flake-inputs;
      extraSpecialArgs.upperConfig = config;
      users.${config.primaryUser} = import ./home.nix;
    };
  };
}
