{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    home.sessionVariables = { TERM = lib.mkForce "xterm-256color"; };
  };
}
