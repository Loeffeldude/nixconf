#!/usr/bin/env bash

source "$HOME/.config/sketchybar/plugins/app_icons.sh"

WORKSPACE=$1

if [ -z "$WORKSPACE" ]; then
    exit 0
fi

# Get all apps in this workspace
APPS=$(aerospace list-windows --workspace "$WORKSPACE" --format "%{app-name}" 2>/dev/null)

# Build icon line
ICON_LINE=""
if [ -z "$APPS" ]; then
    ICON_LINE=" —"
else
    # Use associative array to track unique apps
    declare -A seen_apps
    while IFS= read -r app; do
        if [ -n "$app" ] && [ -z "${seen_apps[$app]}" ]; then
            seen_apps[$app]=1
            icon=$(get_app_icon "$app")
            ICON_LINE="${ICON_LINE} ${icon}"
        fi
    done <<< "$APPS"
fi

sketchybar --set space.$WORKSPACE label="$WORKSPACE$ICON_LINE"
