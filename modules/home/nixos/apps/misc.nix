{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.misc.enable {
    services.flatpak = {
      enable = true;
      packages = [
        "com.ultimaker.cura"
        "de.bund.ausweisapp.ausweisapp2"
        "org.qbittorrent.qBittorrent"
        "org.raspberrypi.rpi-imager"
      ];
    };

    home.packages = with pkgs; [
      protonvpn-gui
      # rustdesk
      blender
      wineWowPackages.stable
      winetricks
    ];
  };
}

