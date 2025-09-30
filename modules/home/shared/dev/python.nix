{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.python;

in {

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Python interpreters
      python311

      # Python package managers and build tools
      pipx
      poetry
      uv
      pdm

      # Python virtual environment tools
      python311Packages.virtualenv

    ];
  };
}
