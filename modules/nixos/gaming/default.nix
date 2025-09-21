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

    environment.systemPackages = with pkgs; [
      # XBOX controller drivers for wireless
      linuxKernel.packages.linux_6_12.xpadneo
    ];
    hardware.xpadneo.enable = true;
  };
}
