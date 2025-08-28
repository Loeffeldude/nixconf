{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.productivity.enable {
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
    home.packages = with pkgs; [ thunderbird ];

    programs.firefox = {
      enable = true;
    };
  };
}
