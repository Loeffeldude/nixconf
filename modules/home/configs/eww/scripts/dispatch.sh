#!/usr/bin/env bash
set -euo pipefail
[[ $1 =~ ^-?[0-9]+$ ]]
name=$(hyprctl -j workspaces | jq -er --argjson id "$1" '.[] | select(.id == $id) | .name')
if [[ $name == special:* ]]; then
  hyprctl dispatch togglespecialworkspace "${name#special:}"
elif (( $1 < 0 )); then
  hyprctl dispatch workspace "name:$name"
else
  hyprctl dispatch workspace "$1"
fi
