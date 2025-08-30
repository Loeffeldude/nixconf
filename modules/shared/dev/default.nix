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
      dev.enable = true;
      apps = {
        enable = true;
        dev.enable = true;
      };
    };
  };

}
