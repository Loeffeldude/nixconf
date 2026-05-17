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
            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";
            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";
            "${mod}+Ctrl+Shift+h" = "resize shrink width 50 px or 5 ppt";
            "${mod}+Ctrl+Shift+l" = "resize grow width 50 px or 5 ppt";
            "${mod}+Ctrl+k" = "resize shrink height 50 px or 5 ppt";
            "${mod}+Ctrl+j" = "resize grow height 50 px or 5 ppt";
            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
            "${mod}+Shift+1" = "move container to workspace number 1";
            "${mod}+Shift+2" = "move container to workspace number 2";
            "${mod}+Shift+3" = "move container to workspace number 3";
            "${mod}+Shift+4" = "move container to workspace number 4";
            "${mod}+Shift+5" = "move container to workspace number 5";
            "${mod}+Shift+6" = "move container to workspace number 6";
            "${mod}+Shift+7" = "move container to workspace number 7";
            "${mod}+Shift+8" = "move container to workspace number 8";
            "${mod}+Shift+9" = "move container to workspace number 9";
            "${mod}+Tab" = "workspace back_and_forth";
            "${mod}+c" = "exec qdbus org.kde.klipper /klipper org.kde.klipper.klipper.showKlipperPopupMenu";
            "Print" = "exec spectacle -r -c";
            "Shift+Print" = "exec spectacle -f";
            "${mod}+p" = "layout toggle split";
            "${mod}+Shift+s" = "layout stacking";
            "${mod}+Shift+t" = "layout tabbed";
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
        for_window [class="pavucontrol"] floating enable
        for_window [class="nm-connection-editor"] floating enable
        for_window [class="blueberry.py"] floating enable
        for_window [class="blueman-manager"] floating enable
        for_window [title="Picture-in-Picture"] sticky enable, floating enable
        workspace 1 output DP-0
        workspace 2 output DP-0
        workspace 3 output DP-0
        workspace 4 output DP-0
        workspace 5 output HDMI-0
        workspace 6 output HDMI-0
        workspace 7 output HDMI-0
        workspace 8 output HDMI-0
        workspace 9 output HDMI-0
        exec --no-startup-id "${pkgs.procps}/bin/pkill -x kwin_x11 2>/dev/null || true"
      '';
    };

    programs.eww = {
      enable = true;
      configDir = ../../configs/eww-plasma-i3;
    };

    services.dunst.enable = false;

    home.activation.disablePlasmaMetaQ = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      shortcuts_file="$HOME/.config/kglobalshortcutsrc"

      if [ -f "$shortcuts_file" ]; then
        ${pkgs.gnused}/bin/sed -i 's/^manage activities=.*/manage activities=none,none,Show Activity Switcher/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 1=.*/activate task manager entry 1=none,none,Activate Task Manager Entry 1/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 2=.*/activate task manager entry 2=none,none,Activate Task Manager Entry 2/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 3=.*/activate task manager entry 3=none,none,Activate Task Manager Entry 3/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 4=.*/activate task manager entry 4=none,none,Activate Task Manager Entry 4/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 5=.*/activate task manager entry 5=none,none,Activate Task Manager Entry 5/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 6=.*/activate task manager entry 6=none,none,Activate Task Manager Entry 6/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 7=.*/activate task manager entry 7=none,none,Activate Task Manager Entry 7/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 8=.*/activate task manager entry 8=none,none,Activate Task Manager Entry 8/' "$shortcuts_file"
        ${pkgs.gnused}/bin/sed -i 's/^activate task manager entry 9=.*/activate task manager entry 9=none,none,Activate Task Manager Entry 9/' "$shortcuts_file"
      fi

      ${pkgs.procps}/bin/pkill -x kglobalacceld 2>/dev/null || true
    '';

    systemd.user.services.plasma-kwin_x11 = {
      Unit = {
        Description = "i3 Window Manager";
        After = [ "plasma-kcminit.service" ];
        PartOf = [ "graphical-session.target" ];
        Before = [ "plasma-workspace-x11.target" "shutdown.target" ];
      };
      Service = {
        ExecStart = "${pkgs.i3}/bin/i3";
        Slice = "session.slice";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "plasma-workspace-x11.target" ];
    };

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
