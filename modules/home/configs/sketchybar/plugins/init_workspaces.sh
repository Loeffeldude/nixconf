#!/usr/bin/env bash

# Wait for aerospace to be ready
sleep 2

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

# Get all monitors
MONITORS=$(/run/current-system/sw/bin/aerospace list-monitors | cut -d' ' -f1)

# Create workspace items for each monitor
for monitor in $MONITORS; do
    # Get workspaces for this monitor
    WORKSPACES=$(/run/current-system/sw/bin/aerospace list-workspaces --monitor "$monitor")
    
    for sid in $WORKSPACES; do
        # Calculate display mask for sketchybar (1-indexed)
        DISPLAY_MASK=$((1 << (monitor - 1)))
        
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
            label.font="SF Pro:Regular:13.0" \
            click_script="aerospace workspace $sid" \
            update_freq=1 \
            script="$CONFIG_DIR/plugins/aerospace.sh $sid"
        
        # Initial app icon update
        "$CONFIG_DIR/plugins/aerospace_windows.sh" "$sid"
    done
done
