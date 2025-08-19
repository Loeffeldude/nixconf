{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev.python;

in {

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Python interpreters
      python3
      python311
      python312

      # Python package managers and build tools
      pip
      pipx
      poetry
      uv
      pdm

      # Python dev tools
      black # code formatter
      ruff # linter and formatter
      mypy # type checker
      pylint # static analysis
      flake8 # style guide enforcement
      isort # import sorter
      autopep8 # auto formatter

      # Python debugging and profiling
      python311Packages.ipython
      python311Packages.ipdb
      python311Packages.pytest
      python311Packages.pytest-cov
      python311Packages.pytest-xdist

      # Python virtual environment tools
      python311Packages.virtualenv
      python311Packages.virtualenvwrapper

      # Python REPL and notebooks
      python311Packages.jupyter
      python311Packages.jupyterlab
    ];
  };
}
