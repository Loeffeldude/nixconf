#!/usr/bin/env bash
set -euo pipefail

config=$(dirname "$(dirname "$0")")
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

watch_monitors() {
  exec 3< <(socat -u "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" -)
  local socket_pid=$!
  trap 'kill "$socket_pid" 2>/dev/null || true' EXIT
  trap 'exit 0' TERM INT
  sync_monitors
  while IFS= read -r event <&3; do
    case "${event%%>>*}" in
      monitoradded*|monitorremoved*) sync_monitors ;;
    esac
  done
}

if eww -c "$config" ping > /dev/null 2>&1; then
  printf '%s\n' "Eww is already running for $config; stop it before starting the service." >&2
  exit 1
fi

eww -c "$config" daemon --no-daemonize &
daemon=$!
watcher=""
trap 'kill "$daemon" ${watcher:+"$watcher"} 2>/dev/null || true' EXIT
trap 'exit 0' TERM INT

# The daemon creates its IPC socket asynchronously.
for attempt in {1..50}; do
  kill -0 "$daemon"
  if eww -c "$config" ping > /dev/null 2>&1; then
    break
  fi
  sleep 0.1
done
eww -c "$config" ping > /dev/null
watch_monitors &
watcher=$!
wait -n "$daemon" "$watcher"
# Losing either process requires restarting the whole service.
exit 1
