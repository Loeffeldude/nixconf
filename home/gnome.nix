{ config, pkgs, lib, ... }: {
  dconf = { enable = true; };
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

  systemd.user.sessionVariables = config.home.sessionVariables;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };
  gtk = {
    enable = true;
    theme = {
      name = "adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
