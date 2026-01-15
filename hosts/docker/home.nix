{ config, pkgs, lib, ... }: {
  imports = [
    ../../modules/home/shared/dev
  ];

  home.username = "loeffel";
  home.homeDirectory = "/home/loeffel";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = lib.mkForce false;

  home.packages = with pkgs; [
    htop
    ripgrep
    fd
    jq
  ];
}
