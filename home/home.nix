{ config, pkgs, ... }:

{
  home.username = "loeffel";
  home.homeDirectory = "/home/loeffel/";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.packages = with pkgs; [
    neofetch

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    pkgs.oh-my-zsh
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Loeffeldude";
    userEmail = "kraetschmerni@gmail.com";
  };

  programs.zsh = { };

  programs.zsh = {
    enable = true;
    shellAliases = { ll = "ls -l"; };
  };

  programs.oh-my-zsh = {
    enable = true;
    plugins = [ ];
    theme = "agnoster";
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
