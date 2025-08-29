{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.gaming.enable {

    home.packages = with pkgs; [
      gamescope # Valve's micro-compositor for gaming
      mangohud # Performance overlay
      goverlay # GUI for MangoHud configuration
      lutris # Another game launcher
      input-remapper # Universal input device remapping
      retroarch
      retroarch-assets
      retroarch-joypad-autoconfig
    ];
  };
}
