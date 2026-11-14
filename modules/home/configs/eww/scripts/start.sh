#!/usr/bin/env bash
set -euo pipefail

config=$(dirname "$(dirname "$0")")
exec 9>"$XDG_RUNTIME_DIR/eww-bars.lock"
flock -n 9 || exit 0
declare -A bars=()

sync_monitors() {
  local monitors name
  monitors=$(hyprctl -j monitors | jq -r '.[] | select(.disabled == false and .mirrorOf == "none") | .name')
  for name in "${!bars[@]}"; do
    if ! [[ $'\n'"$monitors"$'\n' == *$'\n'"$name"$'\n'* ]]; then
      eww -c "$config" close "bar-$name"
      unset 'bars[$name]'
    fi
  done
  while IFS= read -r name; do
    [[ -n $name ]] || continue
    [[ -v bars[$name] ]] && continue
    eww -c "$config" open bar --id "bar-$name" --arg "monitor=$name"
    bars[$name]=1
  done <<< "$monitors"
}

eww -c "$config" daemon 9>&-
exec 3< <(socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" - 9>&-)
sync_monitors
while IFS= read -r event <&3; do
  case "${event%%>>*}" in
    monitoradded*|monitorremoved*) sync_monitors ;;
  esac
done
