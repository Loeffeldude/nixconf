#!/usr/bin/env bash

# Colors matching EWW
ACCENT="0xffde935f"
ACCENT_BG="0x40de935f"
OCCUPIED="0xffb5bd68"
OCCUPIED_BG="0x1ab5bd68"
INACTIVE="0xff909090"
PANEL="0xcc1d1f21"
# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Ensure aerospace is in PATH
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Get workspace ID from NAME or from argument
if [ -n "$1" ]; then
    WORKSPACE="$1"
else
    # Extract workspace ID from $NAME (e.g., "space.1" -> "1")
    WORKSPACE="${NAME#space.}"
fi

# Check if workspace is occupied
WINDOWS=$(/run/current-system/sw/bin/aerospace list-windows --workspace "$WORKSPACE" 2>/dev/null | wc -l)

# Find which monitor this workspace is on and check if it's visible
IS_VISIBLE=false
for monitor in $(/run/current-system/sw/bin/aerospace list-monitors | cut -d' ' -f1); do
    VISIBLE_WS=$(/run/current-system/sw/bin/aerospace list-workspaces --monitor "$monitor" --visible)
    if [ "$VISIBLE_WS" = "$WORKSPACE" ]; then
        IS_VISIBLE=true
        break
    fi
done

# Update workspace highlight
if [ "$IS_VISIBLE" = "true" ]; then
    # Active workspace
    sketchybar --set $NAME label.color=$ACCENT \
                        background.color=$ACCENT_BG
elif [ "$WINDOWS" -gt 0 ]; then
    # Occupied but not active
    sketchybar --set $NAME label.color=$OCCUPIED \
                        background.color=$OCCUPIED_BG
else
    # Inactive and empty
    sketchybar --set $NAME label.color=$INACTIVE \
                        background.color=$PANEL
fi

# Always update app icons
"$CONFIG_DIR/plugins/aerospace_windows.sh" "$WORKSPACE"
