{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;
in {
  config = mkIf cfg.media.enable {
    services.flatpak = {
      enable = true;
      packages =
        [ ];

    };

    home.packages = with pkgs; [ vlc spotify obs-studio ];
  };
}
