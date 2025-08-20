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

      # Python debugging and profiling
      python311Packages.ipython
      python311Packages.ipdb
      python311Packages.pytest
      python311Packages.pytest-cov
      python311Packages.pytest-xdist

      # Python virtual environment tools
      python311Packages.virtualenv

      # Python REPL and notebooks
      python311Packages.jupyter
      python311Packages.jupyterlab
    ];
  };
}
