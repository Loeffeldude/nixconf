{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    programs.zsh = {
      shellAliases = {
        yank = "pbcopy";
      };
    };

  };
}



