{ config, pkgs, ... }: {
  home.packages = with pkgs; [ oh-my-zsh ];

  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
  };

  programs.oh-my-zsh = {
    enable = true;
    plugins = [ "git" ];
    theme = "agnoster";
  };
}
