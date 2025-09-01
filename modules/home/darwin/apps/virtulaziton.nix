{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ discord ];
  };
}
