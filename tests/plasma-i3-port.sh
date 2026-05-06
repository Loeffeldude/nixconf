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
assert_contains modules/home/nixos/desktop/kde.nix '"Print" = "exec spectacle -r -c";'
assert_contains modules/home/nixos/desktop/kde.nix '"Shift\+Print" = "exec spectacle -f";'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+c" = "exec qdbus org\.kde\.klipper /klipper org\.kde\.klipper\.klipper\.showKlipperPopupMenu";'
assert_contains modules/home/nixos/desktop/kde.nix 'picom -b'
assert_contains modules/home/nixos/desktop/kde.nix 'eww open bar0'
assert_contains modules/home/nixos/desktop/kde.nix 'services\.dunst\.enable = false;'
