{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.misc.enable {
    home.packages = with pkgs; [ bitwarden-desktop yt-dlg ];
    # Sets up ssh agent sock probably 
    # TODO: should move this to its onw file 
    home.sessionVariables = {
      SSH_AUTH_SOCK = "${home.homeDirectory}/.bitwarden-ssh-agent.sock";
    };
  };
}

