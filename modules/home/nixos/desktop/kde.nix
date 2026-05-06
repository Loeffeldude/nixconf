# EXPERIMENTAL: KDE Plasma with i3 window manager integration
# Currently not in use - main setup uses Hyprland
# Kept for future reference/testing
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.desktop.kde;
in {

  options.desktop.kde = { enable = mkEnableOption "enable kde"; };

  config = mkIf cfg.enable {
    # i3 configuration for use with KDE Plasma
    xsession.windowManager.i3 = {
      enable = true;
      config = {
        modifier = "Mod4";
        terminal = "wezterm start";

        fonts = {
          names = [ "SF Pro" ];
          size = 10.0;
        };

        gaps = {
          inner = 8;
          outer = 8;
          smartGaps = true;
        };

        window = {
          border = 1;
          titlebar = false;
        };

        floating = {
          border = 1;
          titlebar = false;
        };

        focus = {
          followMouse = true;
          mouseWarping = false;
        };

        colors = {
          focused = {
            border = "#de935f";
            background = "#de935f";
            text = "#ffffff";
            indicator = "#de935f";
            childBorder = "#de935f";
          };
          focusedInactive = {
            border = "#4d5057";
            background = "#4d5057";
            text = "#c5c8c6";
            indicator = "#4d5057";
            childBorder = "#4d5057";
          };
          unfocused = {
            border = "#4d5057";
            background = "#1d1f21";
            text = "#c5c8c6";
            indicator = "#4d5057";
            childBorder = "#4d5057";
          };
          urgent = {
            border = "#cc6666";
            background = "#cc6666";
            text = "#ffffff";
            indicator = "#cc6666";
            childBorder = "#cc6666";
          };
        };

        bars = [ ];

        startup = [
          { command = "eww daemon && eww open bar0 && eww open bar1"; always = false; notification = false; }
          { command = "picom -b"; always = false; notification = false; }
          { command = "nm-applet --indicator"; always = false; notification = false; }
          { command = "blueman-applet"; always = false; notification = false; }
          { command = "feh --bg-scale ~/.background-image-dark"; always = false; notification = false; }
        ];

        keybindings =
          let
            mod = "Mod4";
            logout = "qdbus org.kde.ksmserver /KSMServer logout 0 0 0";
          in
          {
            "${mod}+Return" = "exec wezterm start";
            "${mod}+space" = "exec krunner";
            "${mod}+q" = "kill";
            "${mod}+Shift+e" = "exec ${logout}";
            "${mod}+v" = "floating toggle";
            "${mod}+f" = "fullscreen toggle";
            "${mod}+m" = "fullscreen toggle";
            "${mod}+Tab" = "workspace back_and_forth";
            "${mod}+c" = "exec qdbus org.kde.klipper /klipper org.kde.klipper.klipper.showKlipperPopupMenu";
            "Print" = "exec spectacle -r -c";
            "Shift+Print" = "exec spectacle -f";
            "${mod}+p" = "layout toggle split";
          };
      };

      extraConfig = ''
        for_window [window_role="pop-up"] floating enable
        for_window [window_role="task_dialog"] floating enable
        for_window [class="plasmashell"] floating enable
        for_window [class="Plasma"] floating enable, border none
        for_window [class="krunner"] floating enable, border none
        for_window [class="Klipper"] floating enable, border none
        for_window [class="systemsettings"] floating enable
        for_window [title="Picture-in-Picture"] sticky enable, floating enable
        workspace 1 output DP-1
        workspace 2 output DP-1
        workspace 3 output DP-1
        workspace 4 output DP-1
        workspace 5 output HDMI-A-1
        workspace 6 output HDMI-A-1
        workspace 7 output HDMI-A-1
        workspace 8 output HDMI-A-1
        exec --no-startup-id "killall kwin_x11 2>/dev/null || true"
      '';
    };

    programs.eww = {
      enable = true;
      configDir = ../../configs/eww-plasma-i3;
    };

    services.dunst.enable = false;

    home.file.".background-image-dark".source = ../../../../media/nix-dark.png;
    home.file.".background-image-bright".source = ../../../../media/nix-bright.png;

    home.packages = with pkgs; [
      socat
      jq
      btop
      playerctl
      gsettings-desktop-schemas
      pwmenu
      xclip
    ];

    home.sessionVariables = {
      GTK_THEME = "Yaru-blue-dark";
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
      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Yaru-blue-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "yaru-blue";
      style = {
        name = "Yaru-blue-dark";
        package = pkgs.yaru-theme;
      };
    };
  };
}
