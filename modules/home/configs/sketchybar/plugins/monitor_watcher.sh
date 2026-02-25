#!/usr/bin/env bash

# Monitor change detection script for sketchybar
# Polls aerospace for monitor changes and triggers workspace reinitialization

# Ensure aerospace is in PATH
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Store the current monitor count
MONITOR_COUNT=$(/run/current-system/sw/bin/aerospace list-monitors 2>/dev/null | wc -l | tr -d ' ')

while true; do
    sleep 2
    
    # Get current monitor count
    CURRENT_COUNT=$(/run/current-system/sw/bin/aerospace list-monitors 2>/dev/null | wc -l | tr -d ' ')
    
    # Check if monitor count changed
    if [ "$CURRENT_COUNT" != "$MONITOR_COUNT" ]; then
        # Monitor count changed, trigger workspace reinitialization
        sketchybar --trigger display_change
        MONITOR_COUNT=$CURRENT_COUNT
    fi
done
