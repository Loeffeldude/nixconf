#!/usr/bin/env bash

ACCENT="0xffC98B60"
FG="0xffD0D0D0"
CONFIG_DIR="$HOME/.config/sketchybar"

# Update workspace highlight
if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.border_color=$ACCENT \
                        label.color=$ACCENT
else
    sketchybar --set $NAME background.border_color=$FG \
                        label.color=$FG
fi

# Always update app icons
"$CONFIG_DIR/plugins/aerospace_windows.sh" "$1"
