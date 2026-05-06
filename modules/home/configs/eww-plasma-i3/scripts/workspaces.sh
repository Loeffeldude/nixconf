#!/usr/bin/env bash
set -euo pipefail

get_workspace_json() {
  local monitor_id="$1"
  local start_ws=$((monitor_id * 4 + 1))
  local end_ws=$((start_ws + 3))
  local target_output="DP-1"
  local active_ws
  local workspaces_json
  local occupied_workspaces
  local json_output="["
  local ws_id

  if [ "$monitor_id" = "1" ]; then
    target_output="HDMI-A-1"
    end_ws=9
  fi

  workspaces_json=$(i3-msg -t get_workspaces)
  active_ws=$(printf '%s\n' "$workspaces_json" | jq -r --arg target_output "$target_output" '.[] | select(.output == $target_output and .visible == true) | .num' | head -n1)
  occupied_workspaces=$(printf '%s\n' "$workspaces_json" | jq -r --arg target_output "$target_output" '.[] | select(.output == $target_output and .num != null) | .num')

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
