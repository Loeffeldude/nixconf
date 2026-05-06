{ config, pkgs, lib, flake-inputs, ... }:
with lib;
let
  cfg = config.dev.python;
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

in {

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Python interpreters
      python313

      # Python package managers and build tools
      pipx
      uv
      # nixos-unstable currently ships a broken pdm dependency set.
      stablePkgs.pdm

      # Python virtual environment tools
      python313Packages.virtualenv

    ] ++ lib.optionals pkgs.stdenv.isLinux [
      poetry
    ] ++ lib.optionals pkgs.stdenv.isDarwin [
      # Use stable nixpkgs poetry on Darwin to avoid Python 3.13 rapidfuzz build issues
      stablePkgs.poetry
    ];
  };
}
