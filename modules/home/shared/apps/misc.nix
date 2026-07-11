{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let
  cfg = config.apps;
  homeDir = config.home.homeDirectory;
  stablePkgs = import flake-inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
    config.permittedInsecurePackages = [ "electron-39.8.10" ];
  };
in
{
  config = mkIf cfg.misc.enable {
    home.packages = with pkgs; [ stablePkgs.bitwarden-desktop yt-dlg wireguard-tools ];

    # Sets up ssh agent sock probably 
    # TODO: should move this to its onw file 
    home.sessionVariables = {
      SSH_AUTH_SOCK = "${homeDir}/.bitwarden-ssh-agent.sock";
    };
  };
}

