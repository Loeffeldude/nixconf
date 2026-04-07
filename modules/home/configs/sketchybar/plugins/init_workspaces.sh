#!/usr/bin/env bash

# Wait for aerospace to be ready
if [ "$1" != "--no-delay" ]; then
    sleep 2
fi

# Ensure aerospace is in PATH
export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

# Colors matching EWW
PANEL="0xcc1d1f21"
ACCENT="0xffde935f"
OCCUPIED="0xffb5bd68"
FG="0xffc5c8c6"
INACTIVE="0xff909090"
# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

# Remove all existing workspace items
sketchybar --remove '/space\..*/'

# Get all monitors
MONITORS=$(/run/current-system/sw/bin/aerospace list-monitors | cut -d' ' -f1)

# Create workspace items for each monitor
for monitor in $MONITORS; do
    # Get workspaces for this monitor
    WORKSPACES=$(/run/current-system/sw/bin/aerospace list-workspaces --monitor "$monitor")
    
    for sid in $WORKSPACES; do
        sketchybar --add item space.$sid left \
            --subscribe space.$sid aerospace_workspace_change \
            --set space.$sid \
            associated_display=$monitor \
            blur_radius=0 \
            background.color=$PANEL \
            background.corner_radius=24 \
            background.height=22 \
            background.drawing=on \
            padding_left=2 \
            padding_right=2 \
            icon.drawing=off \
            label="$sid" \
            label.padding_left=10 \
            label.padding_right=10 \
            label.color=$INACTIVE \
            label.font="Hack Nerd Font:Bold:9.0" \
            click_script="aerospace workspace $sid" \
            script="$CONFIG_DIR/plugins/aerospace.sh $sid"
        
        # Initial app icon update
        "$CONFIG_DIR/plugins/aerospace_windows.sh" "$sid"
    done
done
