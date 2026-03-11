{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.gamedev;

in {
  config = mkIf cfg.godot.enable {
    home.packages = with pkgs; [ godotPackages_4_5.godot ];
    dev.csharp.enable = mkForce true;
  };
}
