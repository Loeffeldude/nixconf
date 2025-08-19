{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.social.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "com.discordapp.Discord"
        "org.ferdium.Ferdium"
        "org.signal.Signal"
        "org.telegram.desktop"
        "us.zoom.Zoom"
      ];
    };
  };
}
