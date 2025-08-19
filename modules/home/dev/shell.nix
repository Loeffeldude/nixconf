{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {

    # needed for sys package autocompletion
    # TODO: move this 

    # home.sessionVariables = { SHELL = "zsh"; };
    programs.zsh = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        vim = "nvim";
        yank = "xclip -selection clipboard";
      };

      oh-my-zsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "intheloop";
      };
    };

  };
}
