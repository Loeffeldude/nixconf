#!/usr/bin/env bash

POPUP_OFF="sketchybar --set apple.logo popup.drawing=off"
POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

# Menu item defaults
MENU_ITEM_DEFAULTS=(
  background.padding_left=7
  background.padding_right=7
  background.border_width=0
  background.drawing=off
  padding_left=0
  padding_right=0
  icon.padding_left=10
  icon.padding_right=10
  icon.color=$FG
  label.padding_right=10
  label.color=$FG
)

apple_logo=(
  icon.drawing=off
  label="Menu"
  label.font="SF Pro:Bold:14.0"
  label.color=$FG
  blur_radius=30
  background.color=0x00000000
  background.border_color=$ACCENT
  background.border_width=1
  background.corner_radius=8
  background.height=26
  background.drawing=on
  padding_left=5
  padding_right=5
  label.padding_left=12
  label.padding_right=12
  click_script="$POPUP_CLICK_SCRIPT"
  popup.background.border_width=1
  popup.background.corner_radius=8
  popup.background.border_color=$ACCENT
  popup.background.color=$BG
)

apple_prefs=(
  icon=
  label="System Settings"
  click_script="open -a 'System Settings'; $POPUP_OFF"
)

apple_activity=(
  icon=
  label="Activity Monitor"
  click_script="open -a 'Activity Monitor'; $POPUP_OFF"
)

apple_lock=(
  icon=
  label="Lock Screen"
  click_script="pmset displaysleepnow; $POPUP_OFF"
)

apple_sleep=(
  icon=
  label="Sleep"
  click_script="pmset sleepnow; $POPUP_OFF"
)

apple_restart=(
  icon=
  label="Restart"
  click_script="osascript -e 'tell app \"System Events\" to restart'; $POPUP_OFF"
)

apple_shutdown=(
  icon=
  label="Shut Down"
  click_script="osascript -e 'tell app \"System Events\" to shut down'; $POPUP_OFF"
)

sketchybar --add item apple.logo left \
           --set apple.logo "${apple_logo[@]}" \
           \
           --add item apple.prefs popup.apple.logo \
           --set apple.prefs "${MENU_ITEM_DEFAULTS[@]}" "${apple_prefs[@]}" \
           \
           --add item apple.activity popup.apple.logo \
           --set apple.activity "${MENU_ITEM_DEFAULTS[@]}" "${apple_activity[@]}" \
           \
           --add item apple.lock popup.apple.logo \
           --set apple.lock "${MENU_ITEM_DEFAULTS[@]}" "${apple_lock[@]}" \
           \
           --add item apple.sleep popup.apple.logo \
           --set apple.sleep "${MENU_ITEM_DEFAULTS[@]}" "${apple_sleep[@]}" \
           \
           --add item apple.restart popup.apple.logo \
           --set apple.restart "${MENU_ITEM_DEFAULTS[@]}" "${apple_restart[@]}" \
           \
           --add item apple.shutdown popup.apple.logo \
           --set apple.shutdown "${MENU_ITEM_DEFAULTS[@]}" "${apple_shutdown[@]}"
