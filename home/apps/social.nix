{ config, pkgs, flake-inputs, ... }: {
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
}
