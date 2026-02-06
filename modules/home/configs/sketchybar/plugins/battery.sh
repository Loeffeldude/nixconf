#!/usr/bin/env bash

PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    exit 0
fi

if [ -n "$CHARGING" ]; then
    ICON="󰂄"
else
    if [ "$PERCENTAGE" -gt 90 ]; then
        ICON="󰁹"
    elif [ "$PERCENTAGE" -gt 60 ]; then
        ICON="󰂀"
    elif [ "$PERCENTAGE" -gt 30 ]; then
        ICON="󰁾"
    elif [ "$PERCENTAGE" -gt 20 ]; then
        ICON="󰁼"
    else
        ICON="󰁺"
    fi
fi

sketchybar --set $NAME icon="$ICON" label="${PERCENTAGE}%"
