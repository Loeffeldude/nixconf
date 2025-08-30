{ config, pkgs, lib, ... }: {
  users.users.loeffel = {
    description = "Nico Krätschmer";
    shell = pkgs.zsh;
  };
  # if we forget this we break the shell so 
  programs.zsh.enable = lib.mkDefault true;
}
