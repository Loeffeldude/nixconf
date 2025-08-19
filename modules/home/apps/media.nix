{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;
in {
  config = mkIf cfg.media.enable {
    services.flatpak = {
      enable = true;
      packages =
        [ "com.spotify.Client" "com.obsproject.Studio" "org.videolan.VLC" ];

    };
  };
}
