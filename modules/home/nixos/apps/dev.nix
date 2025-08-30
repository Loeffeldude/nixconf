{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.dev.enable {
    services.flatpak = {
      packages = [
        "io.dbeaver.DBeaverCommunity"
        "org.eclipse.Java"
        "org.thonny.Thonny"
      ];
    };
  };
}
