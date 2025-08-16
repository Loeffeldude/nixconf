{ config, pkgs, lib, ... }: {
  dconf = { enable = true; };
  dconf.settings = {

    "org/gnome/calendar" = { active-view = "week"; };

    "org/gnome/desktop/background" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri = "/home/loeffel/.background-image";
      picture-uri-dark = "/home/loeffel/.background-image";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Yaru-blue-dark";
      icon-theme = "Yaru-blue";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/screensaver" = {
      color-shading-type = "solid";
      picture-options = "zoom";
      picture-uri-dark = "/home/loeffel/.background-image";
      picture-uri = "/home/loeffel/.background-image";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ ];
      sort-order = [
        "org.gnome.Contacts.desktop"
        "org.gnome.Documents.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/nautilus/icon-view" = { default-zoom-level = "small"; };

    "org/gnome/nautilus/list-view" = { default-zoom-level = "small"; };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dash-max-icon-size = 34;
      dock-fixed = true;
      dock-position = "BOTTOM";
      extend-height = true;
      show-mounts = false;
      show-mounts-network = false;
      show-mounts-only-mounted = true;
      show-trash = false;
    };

    "org/gnome/shell/extensions/ding" = { check-x11wayland = true; };

    "org/gnome/shell/extensions/tiling-assistant" = {
      active-window-hint-color = "rgb(0,115,229)";
      last-version-installed = 46;
      tiling-popup-all-workspace = true;
    };

    "org/gnome/shell" = {
      favorite-apps = [
        "org.wezfurlong.wezterm.desktop"
        "firefox.desktop"
        "org.gnome.Nautilus.desktop"
        "steam.desktop"
        "com.discordapp.Discord.desktop"
      ];
    };

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
