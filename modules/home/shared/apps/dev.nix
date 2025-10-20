{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.dev.enable {
    home.packages = with pkgs; [
      jetbrains.rider
      ghidra
      podman-desktop
      dbeaver-bin
    ];

    home.file.".ideavimrc".source = ../../configs/.ideavimrc;
  };
}
