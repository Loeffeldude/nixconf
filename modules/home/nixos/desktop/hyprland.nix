{ config, pkgs, lib, ... }:

with lib;
let cfg = config.desktop.hyprland;
in {

  options.desktop.hyprland = { enable = mkEnableOption "enable hyprland"; };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      xwayland.enable = true;
      systemd.enable = true;
      extraLuaFiles = {
        vars = {
          autoLoad = false;
          content = ''
            return {
              polkit_agent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1",
            }
          '';
        };
        main = ../../configs/hypr/main.lua;
      };
    };

    programs.eww = {
      enable = true;
    };
    xdg.configFile."eww" = {
      source = ../../configs/eww;
      force = true;
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

    home.file.".config/hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch dpms on
      }

      listener {
        timeout = 300
        on-timeout = loginctl lock-session
      }

      listener {
        timeout = 330
        on-timeout = hyprctl dispatch dpms off
        on-resume = hyprctl dispatch dpms on
      }
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
      GTK_THEME = "adw-gtk3-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
      gtk4.theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
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
        gtk-theme = "adw-gtk3-dark";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };
  };
}
