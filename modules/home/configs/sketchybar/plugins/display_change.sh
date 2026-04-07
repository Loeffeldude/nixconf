#!/usr/bin/env bash

# Get the directory where this script is located
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

export PATH="/run/current-system/sw/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

STATE_FILE="/tmp/sketchybar-monitor-state"
CURRENT_MONITORS=$(/run/current-system/sw/bin/aerospace list-monitors 2>/dev/null | awk '{print $1}' | tr '\n' ' ')

if [ -z "$CURRENT_MONITORS" ]; then
  exit 0
fi

PREVIOUS_MONITORS=""
if [ -f "$STATE_FILE" ]; then
  PREVIOUS_MONITORS=$(<"$STATE_FILE")
fi

if [ "$CURRENT_MONITORS" = "$PREVIOUS_MONITORS" ]; then
  exit 0
fi

printf "%s" "$CURRENT_MONITORS" >"$STATE_FILE"

# Reinitialize workspaces when displays change
"$CONFIG_DIR/plugins/init_workspaces.sh" --no-delay
