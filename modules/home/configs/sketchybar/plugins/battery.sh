#!/usr/bin/env bash

PERCENTAGE=$(pmset -g batt | grep -Eo "[0-9]+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [ -z "$PERCENTAGE" ]; then
    sketchybar --set "$NAME" drawing=off
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

COLOR=0xff96918b
if [ -n "$CHARGING" ]; then
    COLOR=0xffa3be8c
elif [ "$PERCENTAGE" -lt 20 ]; then
    COLOR=0xffe88989
elif [ "$PERCENTAGE" -lt 30 ]; then
    COLOR=0xffde935f
fi
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%" icon.color="$COLOR" label.color="$COLOR" drawing=on
