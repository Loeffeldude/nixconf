{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
  ];
  options.dev = {
    enable = mkEnableOption "enable dev";
  };
  config = mkIf cfg.enable {
    home-manager.users.loeffel = {
      dev.enable = mkDefault true;
      apps = {
        enable = mkDefault true;
        dev.enable = mkDefault true;
      };
    };
  };

}
