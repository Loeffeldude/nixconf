{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.docker;

in {
  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    users.users.${config.primaryUser}.extraGroups = [ "docker" ];
  };

}
