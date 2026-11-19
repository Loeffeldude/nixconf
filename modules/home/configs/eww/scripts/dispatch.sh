#!/usr/bin/env bash
set -euo pipefail
[[ $1 =~ ^-?[0-9]+$ ]]
workspace=$(hyprctl -j workspaces | jq -ec --argjson id "$1" '.[] | select(.id == $id)')
name=$(jq -r '.name' <<< "$workspace")
if [[ $name == special:* ]]; then
  monitor=$(jq -er '.monitor' <<< "$workspace")
  hyprctl dispatch focusmonitor "$monitor"
  hyprctl dispatch togglespecialworkspace "${name#special:}"
elif (( $1 < 0 )); then
  hyprctl dispatch workspace "name:$name"
else
  hyprctl dispatch workspace "$1"
fi
