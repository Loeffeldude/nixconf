{ config, pkgs, flake-inputs, ... }: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.ultimaker.cura"
      "de.bund.ausweisapp.ausweisapp2"
      "org.qbittorrent.qBittorrent"
      "org.raspberrypi.rpi-imager"
    ];
  };
}

