#!/usr/bin/env bash

get_mpris_info() {
  players=$(playerctl -l 2>/dev/null)
  
  if [ -z "$players" ]; then
    echo '{"status": "stopped", "artist": "", "title": "", "player": ""}'
    return
  fi
  
  player=$(echo "$players" | head -n1)
  status=$(playerctl -p "$player" status 2>/dev/null || echo "stopped")
  
  if [ "$status" = "stopped" ] || [ "$status" = "Stopped" ]; then
    echo '{"status": "stopped", "artist": "", "title": "", "player": ""}'
    return
  fi
  
  artist=$(playerctl -p "$player" metadata artist 2>/dev/null || echo "")
  title=$(playerctl -p "$player" metadata title 2>/dev/null || echo "")
  
  # Truncate if too long
  if [ ${#artist} -gt 20 ]; then
    artist="${artist:0:17}..."
  fi
  if [ ${#title} -gt 20 ]; then
    title="${title:0:17}..."
  fi
  
  status_lower=$(echo "$status" | tr '[:upper:]' '[:lower:]')
  
  artist=${artist//$'\n'/ }
  title=${title//$'\n'/ }

  jq -c -n --arg status "$status_lower" \
        --arg artist "$artist" \
        --arg title "$title" \
        --arg player "$player" \
        '{status: $status, artist: $artist, title: $title, player: $player}'
}

get_mpris_info

playerctl -F metadata 2>/dev/null | while read -r _; do
  get_mpris_info
done
