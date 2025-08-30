{ config, lib, pkgs, ... }:

with lib;

let cfg = config.gaming;

in {
  config = mkIf cfg.enable {
    programs.gamemode.enable = true;
  };
}
