#!/usr/bin/env bash

# Map app class to Nerd Font icon
get_app_icon() {
  case "$1" in
  firefox* | Firefox*) echo "" ;;
  chromium* | chrome* | Google-chrome*) echo "" ;;
  *wezterm* | kitty | alacritty | foot | wterm) echo "" ;;
  *code* | Code | VSCodium | code-oss) echo "󰨞" ;;
  nvim | neovim | vim) echo "" ;;
  spotify | Spotify) echo "" ;;
  discord | Discord | vesktop) echo "󰙯" ;;
  slack | Slack) echo "󰒱" ;;
  telegram* | Telegram*) echo "󰍡" ;;
  thunar | nautilus | dolphin | pcmanfm | nemo) echo "" ;;
  *office* | libreoffice*) echo "" ;;
  gimp | Gimp) echo "" ;;
  inkscape | Inkscape) echo "" ;;
  blender | Blender) echo "󰂫" ;;
  obs | obs-studio) echo "󰑋" ;;
  mpv | vlc | celluloid) echo "󰕼" ;;
  steam | Steam) echo "󰓓" ;;
  *pdf* | okular | evince | zathura) echo "󰈦" ;;
  thunderbird | evolution | mailspring) echo "󰇮" ;;
  *) echo "󰣆" ;;
  esac
}

# Get workspaces for a specific monitor
get_workspaces() {
  local monitor_id="$1"

  # Determine workspace range based on monitor ID
  # Monitor 0 (HDMI-A-1): workspaces 1-3
  # Monitor 1 (DP-1): workspaces 4-6
  local start_ws=$((monitor_id * 3 + 1))
  local end_ws=$((start_ws + 2))

  # Get all workspaces data
  local all_workspaces=$(hyprctl workspaces -j)
  local all_clients=$(hyprctl clients -j)
  local active_workspace=$(hyprctl monitors -j | jq --argjson mid "$monitor_id" '.[] | select(.id == $mid).activeWorkspace.id')

  # Build JSON array
  local json_output="["
  for ws_id in $(seq $start_ws $end_ws); do
    # Check if workspace exists and has windows
    local ws_info=$(echo "$all_workspaces" | jq --argjson id "$ws_id" '.[] | select(.id == $id)')
    local has_windows=$(echo "$ws_info" | jq -r '.windows // 0')

    # Check if this is the active workspace on this monitor
    local is_active="false"
    if [ -n "$active_workspace" ] && [ "$ws_id" -eq "$active_workspace" ]; then
      is_active="true"
    fi

    local occupied="false"
    if [ -n "$has_windows" ] && [ "$has_windows" -gt 0 ]; then
      occupied="true"
    fi

    # Get apps as JSON array
    local apps_json="[]"
    if [ "$occupied" = "true" ]; then
      local apps_data=$(echo "$all_clients" | jq -c --argjson wsid "$ws_id" \
        'map(select(.workspace.id == $wsid)) | map({class: .class, name: .initialTitle})')

      declare -A app_counts
      declare -A app_names
      while IFS='|' read -r app_class app_name; do
        if [ -n "$app_class" ]; then
          app_counts["$app_class"]=$((${app_counts["$app_class"]:-0} + 1))
          app_names["$app_class"]="$app_name"
        fi
      done < <(echo "$apps_data" | jq -r '.[] | "\(.class)|\(.name)"')

      local first=true
      apps_json="["
      for app_class in "${!app_counts[@]}"; do
        local icon=$(get_app_icon "$app_class")
        local app_name="${app_names[$app_class]}"
        local count=${app_counts["$app_class"]}

        if [ "$first" = false ]; then
          apps_json="${apps_json},"
        fi
        apps_json="${apps_json}{\"icon\":\"$icon\",\"name\":\"$app_name\",\"count\":$count}"
        first=false
      done
      apps_json="${apps_json}]"
    fi

    json_output="${json_output}{\"id\":$ws_id,\"active\":$is_active,\"occupied\":$occupied,\"apps\":$apps_json}"

    # Add comma if not last workspace
    if [ "$ws_id" -ne "$end_ws" ]; then
      json_output="${json_output},"
    fi
  done
  json_output="${json_output}]"

  echo "$json_output"
}

# Main logic
MONITOR_ID="${1:-0}"

get_workspaces "$MONITOR_ID"

# Listen to Hyprland events and update on changes
socat -u UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock - | while read -r line; do
  get_workspaces "$MONITOR_ID"
done
