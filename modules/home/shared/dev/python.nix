{ config, pkgs, lib, flake-inputs, ... }:
with lib;
let cfg = config.dev.python;

in {

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Python interpreters
      python313

      # Python package managers and build tools
      pipx
      uv
      pdm

      # Python virtual environment tools
      python313Packages.virtualenv

    ] ++ lib.optionals pkgs.stdenv.isLinux [
      poetry
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      # Use stable nixpkgs poetry on Darwin to avoid Python 3.13 rapidfuzz build issues
      flake-inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.poetry
    ];
  };
}
