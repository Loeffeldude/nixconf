{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.gamedev;

in {
  config = mkIf cfg.godot.enable {
    home.packages = with pkgs; [ godot-mono ];
    dev.csharp.enable = mkForce true;
  };
}
