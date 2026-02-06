#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/app_icons.sh"

WORKSPACE=$1

if [ -z "$WORKSPACE" ]; then
  exit 0
fi

export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

APPS=$(/run/current-system/sw/bin/aerospace list-windows --workspace "$WORKSPACE" --format "%{app-name}" 2>/dev/null)

# Build icon line
ICON_LINE=""
if [ -n "$APPS" ]; then
  declare -A app_count
  while IFS= read -r app; do
    if [ -n "$app" ]; then
      ((app_count[$app]++))
    fi
  done <<<"$APPS"

  for app in "${!app_count[@]}"; do
    icon=$(get_app_icon "$app")
    count=${app_count[$app]}
    # Truncate app name to max 10 chars
    app_name="${app:0:10}"
    if [ "$count" -gt 1 ]; then
      ICON_LINE="${ICON_LINE} ${icon}  ${app_name}×${count}"
    else
      ICON_LINE="${ICON_LINE} ${icon}  ${app_name}"
    fi
  done
fi

sketchybar --set space.$WORKSPACE label="$WORKSPACE$ICON_LINE"
