#!/usr/bin/env bash

current_workspace() {
  hyprctl activeworkspace -j | jq -r '.id'
}

current_workspace
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  current_workspace
done
