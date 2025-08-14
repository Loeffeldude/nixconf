{ config, pkgs, lib, ... }: {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };
  };
  home.file.".background-image".source = ../media/nix-dark.png;
}
