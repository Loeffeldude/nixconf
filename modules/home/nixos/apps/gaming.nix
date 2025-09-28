{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.gaming.enable {

    services.flatpak = {
      enable = true;
      packages = [
        "org.desmume.DeSmuME"
        "com.vysp3r.ProtonPlus"
        "io.github.radiolamp.mangojuice"
      ];
    };

    home.packages = with pkgs; [
      prismlauncher
    ];
  };
}
