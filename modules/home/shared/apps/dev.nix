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
      flake-inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.bruno
    ];

    home.file.".ideavimrc".source = ../../configs/.ideavimrc;
  };
}
