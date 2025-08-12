{ config, pkgs, ... }: {

  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
  };
}
