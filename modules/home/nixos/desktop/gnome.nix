{ config, pkgs, lib, ... }:

with lib;
let cfg = config.desktop.gnome;
in {

  options.desktop.gnome = { enable = mkEnableOption "enable gnome"; };
  config = mkIf cfg.enable {
    dconf.enable = true;
    dconf.settings = {
      "org/gnome/mutter" = {
        dynamic-workspaces = false;
      };
      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
      };
      "org/gnome/calendar" = { active-view = "week"; };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "menu:minimize,maximize,close";
        num-workspaces = 1;
      };
      "org/gnome/desktop/background" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri = "/home/loeffel/.background-image-bright";
        picture-uri-dark = "/home/loeffel/.background-image-dark";
        primary-color = "#000000000000";
        secondary-color = "#000000000000";
      };

      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        # gtk-theme = "Yaru-blue-dark";
        icon-theme = "Yaru-blue";
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/screensaver" = {
        color-shading-type = "solid";
        picture-options = "zoom";
        picture-uri-dark = "/home/loeffel/.background-image-dark";
        picture-uri = "/home/loeffel/.background-image-bright";
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
        enabled_extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "apps-menu@gnome-shell-extensions.gcampax.github.com"
          "clipboard-indicator@tudmotu.com"
          "gsconnect@andyholmes.github.io"
          "Vitals@CoreCoding.com"
          "dash-to-dock@micxgx.gmail.com"
          "sound-output-device-chooser@kgshank.net"
          "native-window-placement@gnome-shell-extensions.gcampax.github.com"
        ];
      };

      "org/gnome/desktop/sound" = { event-sounds = false; };
    };

    home.file.".background-image-dark".source = ../../../media/nix-dark.png;
    home.file.".background-image-bright".source = ../../../media/nix-bright.png;

    systemd.user.sessionVariables = config.home.sessionVariables // {
      XCURSOR_THEME = "Yaru";

GSK_RENDERER="ngl";
    };

    qt = {
      enable = true;
      platformTheme.name = "yaru-blue";
      style = {
        name = "Yaru-blue-dark";
        package = pkgs.yaru-theme;
      };
    };
    gtk = {
      enable = true;
      theme = {
        name = "Yaru-blue-dark";
        package = pkgs.yaru-theme;
      };
      cursorTheme = {
        name = "Yaru";
        package = pkgs.yaru-theme;
      };
    };
  };
}
