{ lib, config, pkgs, flake-inputs, ... }:
with lib;
let cfg = config.apps;

in {
  config = mkIf cfg.misc.enable {
    home.packages = with pkgs; [ bitwarden-desktop blender yt-dlg rustdesk ];
    # Sets up ssh agent sock probably 
    # TODO: should move this to its onw file 
    home.sessionVariables = {
      SSH_AUTH_SOCK = "/home/loeffel/.bitwarden-ssh-agent.sock";
    };
  };
}

