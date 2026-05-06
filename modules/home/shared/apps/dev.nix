{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let
  cfg = config.apps;
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };

in {
  config = mkIf cfg.dev.enable {
    home.packages = with pkgs; [
      ghidra
      podman-desktop
      dbeaver-bin
      stablePkgs.bruno
    ] ++ lib.optionals pkgs.stdenv.isLinux [
      jetbrains.rider
    ];

    home.file.".ideavimrc".source = ../../configs/.ideavimrc;
  };
}
