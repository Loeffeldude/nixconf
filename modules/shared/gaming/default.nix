{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  options.gaming = { enable = mkEnableOption "gaming features"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    home-manager.users.${config.primaryUser} = {
      apps = {
        enable = mkDefault true;
        gaming.enable = mkDefault true;
      };
    };
  };
}
