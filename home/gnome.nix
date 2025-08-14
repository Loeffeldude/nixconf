{ config, pkgs, lib, ... }: {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };

    "org/gnome/desktop/interface" = { color-scheme = "prefer-dark"; };
  };
  home.file.".background-image".source = ../media/nix-dark.png;

  systemd.user.sessionVariables =
    config.home-manager.users.loeffel.home.sessionVariables;

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
  };
}
