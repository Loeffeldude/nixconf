# Hyprland Bar

The bar follows Hyprland's actual monitor and workspace state, not workspace ranges.
Each connected output gets a bar, including outputs connected after startup.

- Every bar shows all monitors as separate labeled workspace groups, ordered by
  screen position. Every occupied workspace appears in its owning monitor's
  group, including IDs above 9, named workspaces, and special workspaces.
- The active workspace remains visible even when empty. Empty inactive workspaces
  disappear; the existing Super+number shortcuts still create/switch to them.
- Click a workspace in any group to switch to it on its owning monitor; special
  workspaces focus their owning monitor before toggling their overlay.
- App icons are grouped by class with a count for multiple windows. Hover over a
  workspace to see window titles.
- Moving a workspace between monitors updates both bars via Hyprland events.

The charcoal palette and copper active indicator match the Hyprland border accent.
Status widgets include media, CPU, memory, battery, volume, tray, and a clock.
Click the date/time to toggle a calendar beneath the bar on that monitor. Use the
calendar's arrows to browse months. Click outside the calendar or its close
button to dismiss it. Reopening starts at the current date. This is a date browser, not an agenda
or event integration.

Click the volume indicator for master volume, per-application playback stream
sliders/mute buttons, and an output-device picker. Paused streams remain listed;
applications without an audio stream do not appear. Selecting an output sets the
default and moves existing playback streams to it. Sliders support 0-150%; values
above 100% amplify audio. Controls track external changes. Click outside the
panel or its close button to dismiss it.

## Usage

Home Manager manages the bar as a systemd user service tied to the Hyprland
session. The daemon and monitor watcher restart together and their child
processes are stopped as a group. After rebuilding with `just`, use:

```sh
systemctl --user restart eww-bar
```

The service definition embeds the configuration store path, so Home Manager can
restart it when the configuration changes. `eww reload` alone cannot apply
repository edits to an immutable Nix-store configuration. Do not launch
`scripts/start.sh` separately; it is the service's supervisor.

When migrating from the old manually started watcher, stop that watcher and its
Eww daemon once before starting the service. Diagnose failures with
`journalctl --user -u eww-bar -n 50`.

## Dependencies

Eww, Hyprland (`hyprctl`), Bash, jq, socat, playerctl, PulseAudio tools (`pactl`,
connecting to PipeWire's existing PulseAudio server), WirePlumber (`wpctl`),
and a Nerd Font. The Home Manager module supplies the audio tools and service
command paths. CPU and memory
open btop in WezTerm.

## Development

`bash scripts/workspaces.sh --once` prints a single JSON snapshot.
Run `python3 scripts/test_workspaces.py` for workspace regression tests.
`scripts/workspaces.jq` transforms monitor, workspace, and client JSON into the
per-output widget data. JSON encoding preserves quotes and newlines in titles.
The separate plasma/i3 configuration is not used by this bar.
