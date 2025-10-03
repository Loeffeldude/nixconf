{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  options.gaming = { enable = mkEnableOption "gaming features"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

<<<<<<< HEAD
    home-manager.users.nicokratschmer = {
=======
    home-manager.users.${config.primaryUser} = {
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756
      apps = {
        enable = mkDefault true;
        gaming.enable = mkDefault true;
      };
    };
  };
}
