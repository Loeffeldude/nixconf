# Hyprland Bar

The bar follows Hyprland's actual monitor and workspace state, not workspace ranges.
Each connected output gets a bar, including outputs connected after startup.

- Every occupied workspace appears on its owning monitor, including IDs above 9,
  named workspaces, and special workspaces.
- The active workspace remains visible even when empty. Empty inactive workspaces
  disappear; the existing Super+number shortcuts still create/switch to them.
- Click a workspace to switch to it; special workspaces toggle their overlay.
- App icons are grouped by class with a count for multiple windows. Hover over a
  workspace to see window titles.
- Moving a workspace between monitors updates both bars via Hyprland events.

The charcoal palette and copper active indicator match the Hyprland border accent.
Status widgets include media, CPU, memory, battery, volume, tray, and a clock.

## Usage

Hyprland starts the monitor watcher automatically. To start it manually:

```sh
bash ~/.config/eww/scripts/start.sh
```

After changing styles or widgets, run `eww reload`. When migrating from the old
`bar0`/`bar1` configuration, close the old windows with `eww close-all` first.
Restart the watcher if you manually close its windows.

## Dependencies

Eww, Hyprland (`hyprctl`), Bash, jq, socat, util-linux (`flock`), playerctl,
WirePlumber (`wpctl`), and a Nerd Font. Volume opens pavucontrol; CPU and memory
open btop in WezTerm.

## Development

`bash scripts/workspaces.sh --once` prints a single JSON snapshot.
Run `python3 scripts/test_workspaces.py` for workspace regression tests.
`scripts/workspaces.jq` transforms monitor, workspace, and client JSON into the
per-output widget data. JSON encoding preserves quotes and newlines in titles.
The separate plasma/i3 configuration is not used by this bar.
