{ config, pkgs, ... }:

{
  home.username = "loeffel";
  home.homeDirectory = "/home/loeffel/";

  imports = [ ./git.nix ./terminal.nix ./shell.nix ];

  home.packages = with pkgs; [
    neofetch
    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    oh-my-zsh
  ];

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
