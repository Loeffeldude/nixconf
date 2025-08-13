{ config, pkgs, ... }: {

  # needed for sys package autocompletion
  environment.pathsToLink = [ "/share/zsh" ];

  home.sessionVariables = { SHELL = "zsh"; };
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
