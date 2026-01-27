#!/usr/bin/env bash

workspaces() {
  hyprctl workspaces -j | jq -c 'map({id: .id, urgent: false}) | sort_by(.id)'
}

workspaces
socat -u UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  workspaces
done
