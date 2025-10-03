{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
  ];
  options.dev = {
    enable = mkEnableOption "enable dev";
  };
  config = mkIf cfg.enable {
<<<<<<< HEAD
    home-manager.users.nicokratschmer = {
=======
    home-manager.users.${config.primaryUser} = {
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756
      dev.enable = mkDefault true;
      apps = {
        enable = mkDefault true;
        dev.enable = mkDefault true;
      };
    };
  };

}
