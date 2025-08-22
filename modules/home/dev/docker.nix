{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.docker;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      docker
      docker-compose
      lazydocker
      dive
    ];

  };
}
