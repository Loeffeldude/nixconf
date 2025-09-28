{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  options.gaming = { enable = mkEnableOption "gaming features"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    home-manager.users.loeffel = {
      apps = {
        enable = mkDefault true;
        gaming.enable = mkDefault true;
      };
    };
  };
}
