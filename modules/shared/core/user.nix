{ config, pkgs, lib, ... }: {
  users.users.${config.primaryUser} = {
    description = "Nico Krätschmer";
    shell = pkgs.zsh;
  };

  # if we forget this we break the shell so 
  programs.zsh.enable = lib.mkDefault true;
}
