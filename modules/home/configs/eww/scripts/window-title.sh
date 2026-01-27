#!/usr/bin/env bash

window_title() {
  hyprctl activewindow -j | jq -r '.title'
}

window_title
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  window_title
done
