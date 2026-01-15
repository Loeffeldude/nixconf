{ config, pkgs, ... }:
{
  home.packages = [ pkgs.just ];

  home.file.".justfile".text = ''
    default:
         @just -l
    
    te: tinker-edit

    tinker-edit:
        #!/bin/bash
        persistfile="$HOME/.config/just/tinker/script.php"
        tmpfile="''${JUST_INVOKE_PWD:-.}/.$(${pkgs.util-linux}/bin/uuidgen).php"
        trap "rm -f $tmpfile" EXIT
        
        echo "<?php" > "$tmpfile"
        
        if [[ -f "$persistfile" ]]; then
            tail -n +2 "$persistfile" >> "$tmpfile"
        fi
        
        ''${EDITOR:-vim} "$tmpfile" || exit 1
        [[ -s "$tmpfile" ]] || exit 1
        
        mkdir -p "$(dirname "$persistfile")"
        cp "$tmpfile" "$persistfile"
        
        grep -v '^<?php$' "$tmpfile" | sail tinker
  '';

  programs.zsh.shellAliases.jg = "JUST_INVOKE_PWD=$(pwd) just -g";
}
