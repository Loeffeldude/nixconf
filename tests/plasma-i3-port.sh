#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd -- "$script_dir/.." && pwd)"

cd "$repo_root"

assert_contains() {
  local file="$1"
  local pattern="$2"

  if ! rg -q "$pattern" "$file"; then
    printf 'missing pattern %s in %s\n' "$pattern" "$file" >&2
    exit 1
  fi
}

assert_contains hosts/ms7e57/default.nix 'desktop\.hyprland\.enable = false;'
assert_contains hosts/ms7e57/default.nix 'desktop\.kde\.enable = true;'
assert_contains modules/nixos/desktop/kde/default.nix 'desktopManager\.plasma6\.enable = true;'
assert_contains modules/nixos/desktop/kde/default.nix 'displayManager\.defaultSession = "plasmax11";'
assert_contains modules/nixos/desktop/kde/default.nix 'libinput = \{'
assert_contains modules/nixos/desktop/kde/default.nix 'networkmanagerapplet'
assert_contains modules/nixos/desktop/kde/default.nix 'blueman'
assert_contains modules/nixos/desktop/kde/default.nix 'spectacle'
assert_contains modules/nixos/desktop/kde/default.nix 'picom'
assert_contains modules/nixos/desktop/kde/default.nix 'wmctrl'
assert_contains modules/nixos/desktop/kde/default.nix 'xorg\.xprop'
assert_contains modules/home/nixos/desktop/kde.nix 'programs\.eww = \{'
assert_contains modules/home/nixos/desktop/kde.nix 'configDir = ../../configs/eww-plasma-i3;'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Return" = "exec wezterm start";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+space" = "exec krunner";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+h" = "focus left";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+j" = "focus down";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+k" = "focus up";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+l" = "focus right";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+h" = "move left";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+l" = "move right";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+1" = "workspace number 1";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+9" = "workspace number 9";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+1" = "move container to workspace number 1";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+9" = "move container to workspace number 9";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Ctrl\+Shift\+h" = "resize shrink width 50 px or 5 ppt";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Ctrl\+Shift\+l" = "resize grow width 50 px or 5 ppt";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Ctrl\+k" = "resize shrink height 50 px or 5 ppt";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Ctrl\+j" = "resize grow height 50 px or 5 ppt";'
assert_contains modules/home/nixos/desktop/kde.nix '"Print" = "exec spectacle -r -c";'
assert_contains modules/home/nixos/desktop/kde.nix '"Shift\+Print" = "exec spectacle -f";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+c" = "exec qdbus org\.kde\.klipper /klipper org\.kde\.klipper\.klipper\.showKlipperPopupMenu";'
assert_contains modules/home/nixos/desktop/kde.nix 'picom -b'
assert_contains modules/home/nixos/desktop/kde.nix 'eww open bar0'
assert_contains modules/home/nixos/desktop/kde.nix 'services\.dunst\.enable = false;'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+s" = "layout stacking";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+Shift\+t" = "layout tabbed";'
assert_contains modules/home/nixos/desktop/kde.nix 'for_window \[class="pavucontrol"\] floating enable'
assert_contains modules/home/nixos/desktop/kde.nix 'for_window \[class="nm-connection-editor"\] floating enable'
assert_contains modules/home/nixos/desktop/kde.nix 'for_window \[class="blueberry.py"\] floating enable'
test -f modules/home/configs/eww-plasma-i3/eww.yuck
test -f modules/home/configs/eww-plasma-i3/eww.scss
test -f modules/home/configs/eww-plasma-i3/scripts/workspaces.sh
test -f modules/home/configs/eww-plasma-i3/scripts/window-title.sh
assert_contains modules/home/configs/eww-plasma-i3/eww.yuck 'deflisten workspaces_monitor0'
assert_contains modules/home/configs/eww-plasma-i3/eww.yuck 'deflisten window_title'
assert_contains modules/home/configs/eww-plasma-i3/eww.yuck 'scripts/workspaces.sh 0'
assert_contains modules/home/configs/eww-plasma-i3/eww.yuck 'scripts/workspaces.sh 1'
assert_contains modules/home/configs/eww-plasma-i3/scripts/dispatch.sh 'i3-msg workspace number'
assert_contains modules/home/configs/eww-plasma-i3/scripts/window-title.sh 'xprop -root _NET_ACTIVE_WINDOW'
assert_contains modules/home/configs/eww-plasma-i3/scripts/workspaces.sh 'wmctrl -lx'
