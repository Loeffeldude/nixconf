{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  options.gaming = { enable = mkEnableOption "gaming features"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;

    home-manager.users.loeffel = {
      apps = {
        enable = true;
        gaming.enable = true;
      };
    };
  };
}
