{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;
  };
}
