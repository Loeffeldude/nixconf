#!/usr/bin/env bash

# Check if INFO is available (from media_change event)
if [ -n "$INFO" ]; then
    STATE="$(echo "$INFO" | jq -r '.state')"
    
    if [ "$STATE" = "playing" ]; then
        MEDIA="$(echo "$INFO" | jq -r '.title + " - " + .artist')"
        sketchybar --set $NAME icon.background.image=media.artwork \
                            icon.background.image.drawing=on \
                            label="$MEDIA" \
                            drawing=on
    else
        sketchybar --set $NAME icon.background.image.drawing=off drawing=off
    fi
else
    # Fallback to manual check (no artwork support)
    if pgrep -x "Spotify" > /dev/null; then
        STATE=$(osascript -e 'tell application "Spotify" to player state as string' 2>/dev/null)
        if [ "$STATE" = "playing" ]; then
            TRACK=$(osascript -e 'tell application "Spotify" to name of current track' 2>/dev/null)
            ARTIST=$(osascript -e 'tell application "Spotify" to artist of current track' 2>/dev/null)
            sketchybar --set $NAME icon.background.image.drawing=off \
                                label="$TRACK - $ARTIST" \
                                drawing=on
        else
            sketchybar --set $NAME icon.background.image.drawing=off drawing=off
        fi
    else
        sketchybar --set $NAME icon.background.image.drawing=off drawing=off
    fi
fi
