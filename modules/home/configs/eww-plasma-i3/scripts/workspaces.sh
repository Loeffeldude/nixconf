#!/usr/bin/env bash
set -euo pipefail

get_workspace_json() {
  local monitor_id="$1"
  local start_ws=$((monitor_id * 4 + 1))
  local end_ws=$((start_ws + 3))
  local active_ws
  local raw_windows
  local occupied_workspaces
  local json_output="["
  local ws_id

  active_ws=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused == true).num')
  raw_windows=$(wmctrl -lx)
  occupied_workspaces=$(printf '%s\n' "$raw_windows" | awk '{print $2}' | sort -u)

  for ws_id in $(seq "$start_ws" "$end_ws"); do
    local is_active="false"
    local is_occupied="false"

    if [ "$ws_id" = "$active_ws" ]; then
      is_active="true"
    fi

    if printf '%s\n' "$occupied_workspaces" | grep -qx "$ws_id"; then
      is_occupied="true"
    fi

    json_output+=$(jq -cn \
      --argjson id "$ws_id" \
      --argjson active "$is_active" \
      --argjson occupied "$is_occupied" \
      '{id: $id, active: $active, occupied: $occupied, apps: []}')

    if [ "$ws_id" -lt "$end_ws" ]; then
      json_output+="," 
    fi
  done

  json_output+="]"
  printf '%s\n' "$json_output"
}

monitor_id="${1:-0}"

while true; do
  get_workspace_json "$monitor_id"
  sleep 1
done
