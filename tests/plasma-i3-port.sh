#!/usr/bin/env bash
set -euo pipefail

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
assert_contains modules/home/nixos/desktop/kde.nix 'configDir = ../../configs/eww-plasma-i3;'
assert_contains modules/home/nixos/desktop/kde.nix '"\$\{mod\}\+space" = "exec krunner";'
assert_contains modules/nixos/desktop/kde/default.nix 'picom'
assert_contains modules/nixos/desktop/kde/default.nix 'wmctrl'
