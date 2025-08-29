{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  imports = [
    ./gamedev
    ./utilities.nix
  ];
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      iotop
    ];


  };
}
