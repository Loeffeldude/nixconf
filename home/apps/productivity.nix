{ config, pkgs, flake-inputs, ... }: {
  services.flatpak = {
    enable = true;
    packages = [
      "com.nextcloud.desktopclient.nextcloud"
      "md.obsidian.Obsidian"
      "net.xm1math.Texmaker"
      "com.google.Chrome"
      "org.chromium.Chromium"
      "org.torproject.torbrowser-launcher"
    ];
  };
  programs.firefox = {
    enable = true;
    enableGnomeExtensions = true;
  };
  home.packages = with pkgs; [ bitwarden-desktop bitwarden-cli ];
}

