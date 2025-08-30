{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.gamedev;

in {
  options.dev.gamedev = {
    enable = mkEnableOption "enable gamedev";
  };
  imports = [ ];
}
