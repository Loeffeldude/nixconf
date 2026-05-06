{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let
  cfg = config.apps;
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  config = mkIf cfg.gaming.enable {

    home.packages = with pkgs; [
      gamescope
      mangohud # Performance overlay
      goverlay # GUI for MangoHud configuration
      stablePkgs.lutris # Another game launcher
      input-remapper # Universal input device remapping
      retroarch
      retroarch-assets
      retroarch-joypad-autoconfig
    ];
  };
}
