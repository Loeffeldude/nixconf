{ config, pkgs, lib, ... }:

with lib;
let cfg = config.desktop.hyprland;
in {

  options.desktop.hyprland = { enable = mkEnableOption "enable hyprland"; };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        "$mod" = "SUPER";
        "$terminal" = "wezterm start";

        monitor = [
          "DP-1,preferred,0x0,1"
          "HDMI-A-1,preferred,1920x0,1"
          ",preferred,auto,1"
        ];

        workspace = [
          "1, monitor:0, default:true"
          "2, monitor:0"
          "3, monitor:0"
          "4, monitor:0"
          "5, monitor:1, default:true"
          "6, monitor:1"
          "7, monitor:1"
          "8, monitor:1"
        ];

        exec-once = [
          "eww daemon && eww open bar0 && eww open bar1"
          "dunst"
          "hyprpaper"
          "nm-applet --indicator"
          "blueman-applet"
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
          "wl-paste --type text --watch cliphist store &"
          "wl-paste --type image --watch cliphist store &"
        ];

        env = [
          "XCURSOR_THEME,Yaru"
          "XCURSOR_SIZE,24"
          "GTK_THEME,Yaru-blue-dark"
          "GDK_BACKEND,wayland,x11"
          "QT_QPA_PLATFORM,wayland;xcb"
          "SDL_VIDEODRIVER,wayland"
          "CLUTTER_BACKEND,wayland"
        ];

        general = {
          gaps_in = 8;
          gaps_out = "8,36,8,8";
          border_size = 1;
          "col.active_border" = "rgba(de935faa)";
          "col.inactive_border" = "rgba(4d505780)";
          layout = "dwindle";
          resize_on_border = true;
        };

        decoration = {
          rounding = 6;
          active_opacity = 1.0;
          inactive_opacity = 0.96;

          blur = {
            enabled = true;
            size = 3;
            passes = 2;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(0f0f0fee)";
          };
        };

        animations = {
          enabled = true;
          bezier = "smooth, 0.25, 0.1, 0.25, 1.0";

          animation = [
            "windows, 1, 3, smooth, slide"
            "windowsOut, 1, 3, smooth, slide"
            "border, 1, 5, default"
            "fade, 1, 3, smooth"
            "workspaces, 1, 4, smooth, slidevert"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
          smart_split = false;
        };

        master = {
          new_status = "master";
        };

        input = {
          kb_layout = "de";
          kb_options = "caps:escape";

          follow_mouse = 1;

          touchpad = {
            natural_scroll = true;
            tap-to-click = true;
            middle_button_emulation = true;
          };
          repeat_delay = 400;
          repeat_rate = 60;
          sensitivity = 0;
        };


        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          vrr = 0;
          middle_click_paste = false;
        };

        bind = [
          "$mod, Return, exec, $terminal"
          "$mod, Space, exec, wofi --show drun"
          "$mod, Q, killactive,"
          "$mod SHIFT, E, exit,"
          ", Print, exec, grim -g \"$(slurp)\" - | wl-copy && notify-send \"Screenshot\" \"Copied to clipboard\""
          "SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send \"Screenshot\" \"Saved to ~/Pictures\""
          "$mod, V, togglefloating,"
          "$mod, F, fullscreen, 1"
          "$mod, M, fullscreen, 0"
          "$mod, P, pseudo,"
          "$mod, J, togglesplit,"

          "$mod, h, movefocus, l"
          "$mod, l, movefocus, r"
          "$mod, k, movefocus, u"
          "$mod, j, movefocus, d"

          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, l, movewindow, r"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, j, movewindow, d"

          "$mod CTRL, h, movecurrentworkspacetomonitor, l"
          "$mod CTRL, l, movecurrentworkspacetomonitor, r"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"

          "$mod, Tab, workspace, previous"
          "$mod, C, exec, cliphist list | wofi --dmenu | cliphist decode | wl-copy"

          "$mod, mouse_down, workspace, e+1"
          "$mod, mouse_up, workspace, e-1"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        binde = [
          "$mod CTRL, k, resizeactive, 0 -50"
          "$mod CTRL, j, resizeactive, 0 50"
          "$mod CTRL SHIFT, h, resizeactive, -50 0"
          "$mod CTRL SHIFT, l, resizeactive, 50 0"
        ];

        windowrulev2 = [
          "float,class:^(pavucontrol)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(blueberry.py)$"
          "float,class:^(blueman-manager)$"
          "float,title:^(Picture-in-Picture)$"
          "pin,title:^(Picture-in-Picture)$"
          "opacity 0.0 override,class:^(xwaylandvideobridge)$"
          "noanim,class:^(xwaylandvideobridge)$"
          "nofocus,class:^(xwaylandvideobridge)$"
          "noinitialfocus,class:^(xwaylandvideobridge)$"
        ];
      };
    };

    programs.eww = {
      enable = true;
      configDir = ../../configs/eww;
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

    home.file.".config/hypr/hyprpaper.conf".text = ''
      preload = ~/.background-image-dark
      wallpaper = ,~/.background-image-dark
      splash = false
    '';

    home.file.".background-image-dark".source = ../../../../media/nix-dark.png;
    home.file.".background-image-bright".source = ../../../../media/nix-bright.png;

    home.packages = with pkgs; [
      wofi
      socat
      jq
      btop
      playerctl
      gsettings-desktop-schemas
      pwmenu
      cliphist
    ];

    programs.wofi = {
      enable = true;
      settings = {
        width = 600;
        height = 400;
        location = "center";
        show = "drun";
        prompt = "Search...";
        filter_rate = 100;
        allow_markup = true;
        no_actions = true;
        halign = "fill";
        orientation = "vertical";
        content_halign = "fill";
        insensitive = true;
        allow_images = true;
        image_size = 40;
        gtk_dark = true;
      };
      style = ''
        * {
          font-family: "SF Pro", sans-serif;
          font-size: 14px;
        }
        
        window {
          margin: 0px;
          border: 1px solid #de935f;
          border-radius: 8px;
          background-color: #0f0f0f;
        }
        
        #input {
          margin: 10px;
          padding: 8px 12px;
          border: 1px solid #de935f;
          border-radius: 8px;
          color: #c5c8c6;
          background-color: #1d1f21;
        }
        
        #inner-box {
          margin: 10px;
          border: none;
          background-color: #0f0f0f;
        }
        
        #outer-box {
          margin: 0px;
          border: none;
          background-color: #0f0f0f;
        }
        
        #scroll {
          margin: 0px;
          border: none;
        }
        
        #text {
          margin: 5px;
          border: none;
          color: #c5c8c6;
        }
        
        #entry {
          padding: 8px;
          border-radius: 8px;
          border: 1px solid transparent;
        }
        
        #entry:selected {
          background-color: #373b41;
          border: 1px solid #de935f;
        }
        
        #entry:selected #text {
          color: #de935f;
        }
      '';
    };

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
