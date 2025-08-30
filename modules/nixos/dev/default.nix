{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
    ./docker.nix
  ];
  options.dev = {
    docker.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable { };

}
