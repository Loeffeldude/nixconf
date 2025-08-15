{ config, pkgs, lib, ... }: {
  dconf = { enable = true; };
  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "/home/loeffel/.background-image";
    };
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };
    "org/gnome/shell/favorite-apps" = [
      "org.wezfurlong.wezterm.desktop"
      "org.mozilla.firefox.desktop"
      "org.gnome.Nautilus.desktop"
      "steam.desktop"
      "com.discordapp.Discord.desktop"
    ];

    "org/gnome/desktop/sound" = { event-sounds = false; };
  };
  home.file.".background-image".source = ../media/nix-dark.png;

  systemd.user.sessionVariables = config.home.sessionVariables;

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style = {
      name = "Adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
  };
}
