#!/usr/bin/env bash
set -euo pipefail

snapshot() {
  local monitors workspaces clients
  monitors=$(hyprctl -j monitors)
  workspaces=$(hyprctl -j workspaces)
  clients=$(hyprctl -j clients)
  jq -cn --argjson monitors "$monitors" --argjson workspaces "$workspaces" \
    --argjson clients "$clients" -f "$(dirname "$0")/workspaces.jq"
}

if [[ ${1-} == --once ]]; then
  snapshot
  exit
fi

# Connect before the initial snapshot so workspace changes cannot fall into a gap.
exec 3< <(socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" -)
snapshot
while IFS= read -r event <&3; do
  case "${event%%>>*}" in
    workspace*|focusedmon*|createworkspace*|destroyworkspace*|moveworkspace*|\
    openwindow|closewindow|movewindow*|windowtitle*|urgent|activespecial*|\
    monitoradded*|monitorremoved*) snapshot ;;
  esac
done
