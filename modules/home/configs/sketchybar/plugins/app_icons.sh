#!/usr/bin/env bash

# Map app class to Nerd Font icon
get_app_icon() {
  case "$1" in
  firefox* | Firefox*) echo "" ;;
  bruno* | Bruno*) echo "󰩃" ;;
  chromium* | chrome* | Google-chrome*) echo "" ;;
  *wezterm* | *WezTerm* | kitty | alacritty | foot | wterm) echo "" ;;
  *Teams*) echo "󰊻" ;;
  *code* | Code | VSCodium | code-oss) echo "󰨞" ;;
  nvim | neovim | vim) echo "" ;;
  spotify | Spotify) echo "" ;;
  discord | Discord | vesktop) echo "󰙯" ;;
  slack | Slack) echo "󰒱" ;;
  telegram* | Telegram*) echo "󰍡" ;;
  finder | thunar | nautilus | dolphin | pcmanfm | nemo) echo "" ;;
  *office* | libreoffice*) echo "" ;;
  gimp | Gimp) echo "" ;;
  inkscape | Inkscape) echo "" ;;
  blender | Blender) echo "󰂫" ;;
  obs | obs-studio) echo "󰑋" ;;
  mpv | vlc | celluloid) echo "󰕼" ;;
  steam | Steam) echo "󰓓" ;;
  *pdf* | okular | evince | zathura) echo "󰈦" ;;
  *Outlook* | thunderbird | evolution | mailspring) echo "󰇮" ;;
  *) echo "󰣆" ;;
  esac
}

export -f get_app_icon
