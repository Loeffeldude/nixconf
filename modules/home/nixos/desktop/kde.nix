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

        bars = [];  # Use KDE's plasma panel instead

        startup = [
          { command = "feh --bg-scale ~/.background-image-dark"; always = false; notification = false; }
        ];

        keybindings = let
          mod = "Mod4";
        in {
          # Terminal and launcher
          "${mod}+Return" = "exec wezterm start";
          "${mod}+space" = "exec rofi -show drun";
          
          # Window management
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exec qdbus org.kde.ksmserver /KSMServer logout 0 0 0";
          "${mod}+v" = "floating toggle";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+m" = "fullscreen toggle";
          
          # Focus
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
          
          # Move windows
          "${mod}+Shift+h" = "move left";
          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          
          # Resize windows
          "${mod}+Ctrl+Shift+h" = "resize shrink width 50 px or 5 ppt";
          "${mod}+Ctrl+Shift+l" = "resize grow width 50 px or 5 ppt";
          "${mod}+Ctrl+k" = "resize shrink height 50 px or 5 ppt";
          "${mod}+Ctrl+j" = "resize grow height 50 px or 5 ppt";
          
          # Workspaces
          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          
          # Move to workspace
          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          
          # Tab between workspaces
          "${mod}+Tab" = "workspace back_and_forth";
          
          # Screenshots (using KDE spectacle)
          "Print" = "exec spectacle -r -c";
          "Shift+Print" = "exec spectacle -f";
          
          # Layout
          "${mod}+p" = "layout toggle split";
          "${mod}+Shift+s" = "layout stacking";
          "${mod}+Shift+t" = "layout tabbed";
        };

        assigns = {};
        
        floating.criteria = [
          { class = "^plasmashell$"; }
          { class = "^Plasma$"; }
          { class = "^krunner$"; }
          { class = "^Systemsettings$"; }
          { class = "^pavucontrol$"; }
          { class = "^nm-connection-editor$"; }
          { class = "^blueberry.py$"; }
          { title = "^Picture-in-Picture$"; }
        ];

        window.commands = [
          {
            criteria = { title = "^Picture-in-Picture$"; };
            command = "sticky enable";
          }
          {
            criteria = { class = "^plasmashell$"; };
            command = "border none";
          }
          {
            criteria = { class = "^Plasma$"; };
            command = "border none";
          }
        ];
      };

      extraConfig = ''
        # Don't treat Plasma pop-ups as full windows
        for_window [class="plasmashell"] floating enable
        for_window [class="Plasma"] floating enable, border none
        for_window [title="plasma-desktop"] floating enable, border none
        for_window [title="win7"] floating enable, border none
        for_window [class="krunner"] floating enable, border none
        for_window [class="Kmix"] floating enable, border none
        for_window [class="Klipper"] floating enable, border none
        for_window [class="Plasmoidviewer"] floating enable, border none
        
        # Workspace assignments to monitors (if using dual monitors)
        workspace 1 output DP-1
        workspace 2 output DP-1
        workspace 3 output DP-1
        workspace 4 output DP-2
        workspace 5 output DP-2
        workspace 6 output DP-2
        
        # Kill KWin and use i3 instead
        exec --no-startup-id "killall kwin_x11 2>/dev/null || true"
      '';
    };

    programs.rofi = {
      enable = true;
      theme = "~/.config/rofi/theme.rasi";
      terminal = "wezterm";
      extraConfig = {
        modi = "drun,run,window";
        show-icons = true;
        display-drun = "Applications";
        display-run = "Run";
        display-window = "Windows";
        drun-display-format = "{name}";
        sidebar-mode = true;
      };
    };

    home.file.".config/rofi/theme.rasi".text = ''
      * {
        background-color: #0f0f0f;
        border-color: #de935f;
        text-color: #c5c8c6;
        spacing: 0;
        width: 600px;
      }

      window {
        transparency: "real";
        border: 1px;
        border-radius: 8px;
        padding: 10px;
      }

      mainbox {
        border: 0;
        padding: 0;
      }

      message {
        border: 1px 0px 0px;
        border-color: #de935f;
        padding: 10px;
      }

      textbox {
        text-color: #c5c8c6;
      }

      inputbar {
        children: [prompt,textbox-prompt-colon,entry,case-indicator];
        padding: 10px;
        border: 1px;
        border-radius: 8px;
        border-color: #de935f;
        background-color: #1d1f21;
      }

      prompt {
        text-color: #de935f;
      }

      textbox-prompt-colon {
        expand: false;
        str: ":";
        margin: 0px 0.3em 0em 0em;
        text-color: #de935f;
      }

      entry {
        placeholder: "Search...";
        text-color: #c5c8c6;
      }

      case-indicator {
        text-color: #c5c8c6;
      }

      listview {
        border: 0px;
        padding: 10px 0px 0px;
        scrollbar: true;
        lines: 10;
      }

      scrollbar {
        width: 4px;
        border: 0;
        handle-width: 8px;
        handle-color: #de935f;
        padding: 0;
      }

      element {
        border: 1px;
        border-color: transparent;
        border-radius: 8px;
        padding: 8px;
        margin: 2px 0px;
      }

      element-text {
        background-color: inherit;
        text-color: inherit;
      }

      element.normal.normal {
        background-color: #0f0f0f;
        text-color: #c5c8c6;
      }

      element.selected.normal {
        background-color: #373b41;
        text-color: #de935f;
        border-color: #de935f;
      }

      element.alternate.normal {
        background-color: #0f0f0f;
        text-color: #c5c8c6;
      }

      mode-switcher {
        border: 1px 0px 0px;
        border-color: #de935f;
        padding: 10px 0px 0px 0px;
      }

      button {
        padding: 8px;
        border-radius: 8px;
        text-color: #c5c8c6;
      }

      button.selected {
        background-color: #373b41;
        text-color: #de935f;
        border-color: #de935f;
      }
    '';

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
