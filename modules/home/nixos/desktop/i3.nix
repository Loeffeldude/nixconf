# EXPERIMENTAL: Standalone i3 window manager home-manager configuration
# Currently not in use - main setup uses Hyprland
# Kept for future reference/testing
{ config, pkgs, lib, ... }:

with lib;
let cfg = config.desktop.i3;
in {

  options.desktop.i3 = { enable = mkEnableOption "enable i3"; };

  config = mkIf cfg.enable {
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

        bars = [{
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          fonts = {
            names = [ "SF Pro" ];
            size = 10.0;
          };
          colors = {
            background = "#0f0f0f";
            statusline = "#c5c8c6";
            separator = "#4d5057";
            focusedWorkspace = {
              border = "#de935f";
              background = "#de935f";
              text = "#0f0f0f";
            };
            activeWorkspace = {
              border = "#4d5057";
              background = "#4d5057";
              text = "#c5c8c6";
            };
            inactiveWorkspace = {
              border = "#1d1f21";
              background = "#1d1f21";
              text = "#c5c8c6";
            };
            urgentWorkspace = {
              border = "#cc6666";
              background = "#cc6666";
              text = "#ffffff";
            };
          };
        }];

        startup = [
          { command = "feh --bg-scale ~/.background-image-dark"; always = false; notification = false; }
          { command = "dunst"; always = false; notification = false; }
          { command = "picom -b"; always = false; notification = false; }
          { command = "nm-applet"; always = false; notification = false; }
        ];

        keybindings = let
          mod = "Mod4";
        in {
          # Terminal and launcher
          "${mod}+Return" = "exec wezterm start";
          "${mod}+space" = "exec rofi -show drun";
          
          # Window management
          "${mod}+q" = "kill";
          "${mod}+Shift+e" = "exec i3-msg exit";
          "${mod}+v" = "floating toggle";
          "${mod}+f" = "fullscreen toggle";
          
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
          
          # Screenshots
          "Print" = "exec scrot -s -e 'xclip -selection clipboard -t image/png -i $f && notify-send \"Screenshot\" \"Copied to clipboard\"'";
          "Shift+Print" = "exec scrot ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png -e 'notify-send \"Screenshot\" \"Saved to ~/Pictures\"'";
          
          # Layout
          "${mod}+Shift+p" = "layout toggle split";
          "${mod}+Shift+s" = "layout stacking";
          "${mod}+Shift+t" = "layout tabbed";
        };

        assigns = {};
        
        floating.criteria = [
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
        ];
      };

      extraConfig = ''
        # Disable focus follows mouse for better control
        focus_follows_mouse no
        
        # Workspace assignments to monitors (if using dual monitors)
        workspace 1 output DP-1
        workspace 2 output DP-1
        workspace 3 output DP-1
        workspace 4 output DP-2
        workspace 5 output DP-2
        workspace 6 output DP-2
      '';
    };

    # Picom compositor for transparency and effects
    services.picom = {
      enable = true;
      backend = "glx";
      vSync = true;
      
      settings = {
        corner-radius = 6;
        
        blur = {
          method = "dual_kawase";
          strength = 3;
        };
        
        opacity-rule = [
          "96:class_g = 'Code'"
          "96:class_g = 'Alacritty'"
          "96:class_g = 'org.wezfurlong.wezterm'"
        ];
        
        shadow = true;
        shadow-radius = 12;
        shadow-opacity = 0.75;
        shadow-offset-x = -12;
        shadow-offset-y = -12;
        
        fading = true;
        fade-in-step = 0.03;
        fade-out-step = 0.03;
      };
    };

    # i3status-rust configuration
    programs.i3status-rust = {
      enable = true;
      bars = {
        default = {
          blocks = [
            {
              block = "music";
              format = " $icon {$combo.str(max_w:50) $play $next |}";
            }
            {
              block = "cpu";
              interval = 1;
              format = " $icon $utilization ";
            }
            {
              block = "memory";
              format = " $icon $mem_used_percents ";
              interval = 5;
            }
            {
              block = "disk_space";
              path = "/";
              info_type = "available";
              interval = 60;
              warning = 20.0;
              alert = 10.0;
              format = " $icon $available ";
            }
            {
              block = "net";
              format = " $icon {$signal_strength $ssid|Wired} ";
              interval = 5;
            }
            {
              block = "sound";
              format = " $icon $output_name {$volume|} ";
            }
            {
              block = "battery";
              interval = 10;
              format = " $icon $percentage {$time|} ";
            }
            {
              block = "time";
              interval = 60;
              format = " $icon $timestamp.datetime(f:'%a %d/%m %R') ";
            }
          ];
          settings = {
            theme = {
              theme = "plain";
              overrides = {
                idle_bg = "#0f0f0f";
                idle_fg = "#c5c8c6";
                info_bg = "#0f0f0f";
                info_fg = "#81a2be";
                good_bg = "#0f0f0f";
                good_fg = "#b5bd68";
                warning_bg = "#0f0f0f";
                warning_fg = "#f0c674";
                critical_bg = "#0f0f0f";
                critical_fg = "#cc6666";
                separator = "";
                separator_bg = "auto";
                separator_fg = "auto";
              };
            };
          };
          icons = "awesome6";
        };
      };
    };

    services.dunst = {
      enable = true;
      settings = {
        global = {
          monitor = 0;
          follow = "mouse";
          width = 300;
          height = 300;
          origin = "top-right";
          offset = "10x42";
          scale = 0;
          notification_limit = 3;

          progress_bar = true;
          progress_bar_height = 10;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;

          indicate_hidden = true;
          transparency = 10;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          text_icon_padding = 0;
          frame_width = 1;
          frame_color = "#de935f";
          separator_color = "frame";
          sort = true;

          font = "SF Pro 10";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\\n%b";
          alignment = "left";
          vertical_alignment = "center";
          show_age_threshold = 60;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;

          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;

          sticky_history = true;
          history_length = 20;

          browser = "firefox";
          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          corner_radius = 8;
          ignore_dbusclose = false;

          mouse_left_click = "close_current";
          mouse_middle_click = "do_action, close_current";
          mouse_right_click = "close_all";
        };

        urgency_low = {
          background = "#0f0f0f";
          foreground = "#c5c8c6";
          timeout = 10;
        };

        urgency_normal = {
          background = "#0f0f0f";
          foreground = "#c5c8c6";
          timeout = 10;
        };

        urgency_critical = {
          background = "#cc6666";
          foreground = "#c5c8c6";
          frame_color = "#cc6666";
          timeout = 0;
        };
      };
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
