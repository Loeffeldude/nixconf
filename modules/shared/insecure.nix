{ config, pkgs, lib, flake-inputs, ... }: {
  nixpkgs.config.permittedInsecurePackages = [
    # needed for bitwarden-desktop
    "electron-39.8.10"
  ];
}
