{ config, pkgs, lib, ... }: {
  users.users.loeffel = {
    isNormalUser = true;
    description = "Nico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };
  # if we forget this we break the shell so 
  programs.zsh.enable = lib.mkDefault true;
}
