{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iotop
    ];
  };
}
