{ config, pkgs, lib, ... }: {
  users.users.loeffel = {
    isNormalUser = true;
    description = "Nico Krätschmer";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
  # if we forget this we break the shell so 
  programs.zsh.enable = lib.mkDefault true;
}
