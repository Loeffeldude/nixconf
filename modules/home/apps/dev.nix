{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.dev.enable {
    services.flatpak = {
      packages = [
        "com.jetbrains.Rider"
        "io.dbeaver.DBeaverCommunity"
        "org.eclipse.Java"
        "org.thonny.Thonny"
        "org.ghidra_sre.Ghidra"
      ];
    };
  };
}
