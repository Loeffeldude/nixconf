{ config, pkgs, lib, ... }: {
<<<<<<< HEAD
  users.users.nicokratschmer = {
=======
  users.users.${config.primaryUser} = {
>>>>>>> f276465ad57f25e9173ccaa7aabd411376527756
    description = "Nico Krätschmer";
    shell = pkgs.zsh;
  };

  # if we forget this we break the shell so 
  programs.zsh.enable = lib.mkDefault true;
}
