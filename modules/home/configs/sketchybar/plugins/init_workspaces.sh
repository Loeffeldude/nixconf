#!/usr/bin/env bash

# Wait for aerospace to be ready
sleep 2

# Colors
ACCENT="0xffC98B60"
FG="0xffD0D0D0"
CONFIG_DIR="$HOME/.config/sketchybar"

# Create workspace items
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        blur_radius=30 \
        background.color=0x00000000 \
        background.border_color=$FG \
        background.border_width=1 \
        background.corner_radius=8 \
        background.height=26 \
        background.drawing=on \
        padding_left=5 \
        padding_right=5 \
        icon.drawing=off \
        label="$sid" \
        label.padding_left=12 \
        label.padding_right=12 \
        label.font="JetBrainsMono Nerd Font:Regular:14.0" \
        click_script="aerospace workspace $sid" \
        update_freq=3 \
        script="$CONFIG_DIR/plugins/aerospace.sh $sid"
    
    # Initial app icon update
    "$CONFIG_DIR/plugins/aerospace_windows.sh" "$sid"
done
