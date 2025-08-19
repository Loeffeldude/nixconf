{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.gamedev;

in {
  options.dev.gamedev = {
    enable = mkEnableOption "enable gamedev";
    godot.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  imports = [ ./godot.nix ];
}
