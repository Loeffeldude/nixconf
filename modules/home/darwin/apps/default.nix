{ config, pkgs, flake-inputs, lib, ... }:
with lib;
let cfg = config.apps;

in {
  imports = [
    ./media.nix
    ./social.nix
    ./virtulaziton.nix
  ];
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ rectangle wireguard-tools ];
  };
}
