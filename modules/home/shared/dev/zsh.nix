{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;

in {
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      cdpath = [
        "$HOME/Documents/projects/"
      ];
      shellAliases = {
        ll = "ls -l";
        vim = "nvim";
      };
      initContent = lib.mkAfter "
        export PATH=\"$PATH:$HOME/.local/bin\"
        export PATH=\"$PATH:$HOME/.config/composer/vendor/bin\"
        export PATH=\"$PATH:$HOME/go/bin\"
        ";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "intheloop";
      };
    };

    programs.direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
  };
}





