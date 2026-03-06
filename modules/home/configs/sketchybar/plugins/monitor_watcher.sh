#!/usr/bin/env bash

# Monitor change detection script for sketchybar
# Polls aerospace for monitor changes and triggers workspace reinitialization

# Ensure aerospace is in PATH
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Store current monitor IDs
MONITOR_STATE=$(/run/current-system/sw/bin/aerospace list-monitors 2>/dev/null | awk '{print $1}' | tr '\n' ' ')

while true; do
    sleep 2
    
    # Get current monitor IDs
    CURRENT_STATE=$(/run/current-system/sw/bin/aerospace list-monitors 2>/dev/null | awk '{print $1}' | tr '\n' ' ')

    if [ -z "$CURRENT_STATE" ]; then
        continue
    fi

    # Check if monitor topology changed
    if [ "$CURRENT_STATE" != "$MONITOR_STATE" ]; then
        # Monitor topology changed, trigger workspace reinitialization
        sketchybar --trigger display_change
        MONITOR_STATE=$CURRENT_STATE
    fi
done
