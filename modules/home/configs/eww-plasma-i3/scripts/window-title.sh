#!/usr/bin/env bash
set -euo pipefail

current_title() {
  local window_id
  window_id=$(xprop -root _NET_ACTIVE_WINDOW | awk '{ print $5 }')

  if [ -z "$window_id" ] || [ "$window_id" = "0x0" ]; then
    printf '\n'
    return
  fi

  xprop -id "$window_id" _NET_WM_NAME WM_NAME | sed -E 's/^[^=]+= //; s/^"//; s/"$//'
}

current_title

while true; do
  sleep 1
  current_title
done
