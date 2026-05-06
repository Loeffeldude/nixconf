#!/usr/bin/env bash
set -euo pipefail

current_title() {
  local window_id
  local title

  if ! window_id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk '{ print $5 }'); then
    printf '\n'
    return
  fi

  if [ -z "$window_id" ] || [ "$window_id" = "0x0" ]; then
    printf '\n'
    return
  fi

  if ! title=$(xprop -id "$window_id" _NET_WM_NAME WM_NAME 2>/dev/null | sed -E 's/^[^=]+= //; s/^"//; s/"$//'); then
    printf '\n'
    return
  fi

  printf '%s\n' "$title"
}

current_title

while true; do
  sleep 1
  current_title
done
