{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
    ./docker.nix
  ];
  options.dev = {
    enable = mkEnableOption "enable dev";
    docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
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
