{ config, pkgs, lib, ... }:
with lib;
let cfg = config.dev;
in {
  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      
      settings = {
        manager = {
          show_hidden = false;
          sort_by = "natural";
          sort_dir_first = true;
          linemode = "size";
          show_symlink = true;
        };
        
        preview = {
          tab_size = 2;
          max_width = 600;
          max_height = 900;
        };
      };
      
      theme = {
        manager = {
          border_style = { fg = "#de935f"; };
          selected = { fg = "#de935f"; };
          hovered = { fg = "#c5c8c6"; bg = "#373b41"; };
          preview_hovered = { fg = "#c5c8c6"; bg = "#373b41"; };
        };
        
        status = {
          separator_open = "";
          separator_close = "";
          mode_normal = { fg = "#0f0f0f"; bg = "#b5bd68"; };
          mode_select = { fg = "#0f0f0f"; bg = "#de935f"; };
          mode_unset = { fg = "#0f0f0f"; bg = "#81a2be"; };
        };
        
        input = {
          border = { fg = "#de935f"; };
          title = { fg = "#c5c8c6"; };
          value = { fg = "#de935f"; };
          selected = { bg = "#373b41"; };
        };
      };
      
      keymap = {
        manager.prepend_keymap = [
          { on = [ "g" "h" ]; run = "cd ~"; desc = "Go to home"; }
          { on = [ "g" "c" ]; run = "cd ~/.config"; desc = "Go to config"; }
          { on = [ "g" "d" ]; run = "cd ~/Downloads"; desc = "Go to downloads"; }
          { on = [ "g" "p" ]; run = "cd ~/projects"; desc = "Go to projects"; }
        ];
      };
    };
    
    home.packages = with pkgs; [
      ffmpegthumbnailer
      unar
      poppler-utils
      fd
      ripgrep
      jq
      imagemagick
    ];
  };
}
