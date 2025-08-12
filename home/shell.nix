{ config, pkgs, ... }: {
  home.packages = with pkgs; [ oh-my-zsh ];

  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
  };

  programs.ohMyZsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "agnoster";
  };
}
