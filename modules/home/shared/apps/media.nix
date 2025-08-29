{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;
in {
  config = mkIf cfg.media.enable {
    home.packages = with pkgs; [ vlc spotify obs-studio libreoffice-qt ];
  };
}
