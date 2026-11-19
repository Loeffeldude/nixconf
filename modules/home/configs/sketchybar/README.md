# SketchyBar

The macOS bar follows Eww's flat design: opaque `#101010` background, warm white
text, muted gray labels, orange `#de935f` accents, 40px bar height, no card
backgrounds, and square dark popups. Sound is 800 points wide; Calendar uses the
same compact typography and colors. The macOS system menu is retained.

## Workspaces

Every bar shows all monitors as separate `Screen 1`, `Screen 2`, etc. groups,
with separators between them. Groups are ordered physically left to right using
AeroSpace's `monitor-id`; AppKit screen indices remain the group identities and
labels, so moving a screen changes its position rather than its label. Each group's
visible workspace is highlighted independently. Clicking a workspace switches
to it on its owning monitor.

Occupied AeroSpace workspaces and every monitor's visible workspace are shown.
There is no numeric range limit. Named workspaces work and app icons are grouped
with counts.

Workspace/window/display events update the list. A two-second SketchyBar update
also catches moved windows and monitor hotplug events without a separate watcher
process or stale lock files. Empty inactive workspaces disappear.

## Popups

Click the date/time for a Monday-first calendar with previous/next month controls.
Click volume for master volume, mute, and output selection. Only one popup is
opened at a time. Click its parent again or Close to dismiss it; popups also close
when the pointer leaves the bar/popup area or another app gains focus.

Native macOS differences:

- Master volume is 0-100%, not PipeWire's amplified 150% range.
- macOS does not expose per-application volume adjustment through its standard
  audio controls. No fake app sliders are shown. A separate audio-routing/mixer
  product would be required for that functionality.
- Outputs that do not support software volume (some HDMI/digital devices) need
  their hardware controls.
- SketchyBar uses native popup rows rather than GTK widgets, so calendar layout
  and popup dismissal are not pixel/interaction-identical to Eww.

## Lifecycle

Home Manager's `programs.sketchybar.service` runs the bar under launchd. AeroSpace
no longer launches another instance. Rebuild the Darwin configuration to install
the configuration and its Python, jq, Bash, AeroSpace, and SwitchAudioSource
dependencies. Home Manager manages the service; `sketchybar --reload` reloads the
installed configuration. The launchd command includes the immutable configuration
path so configuration changes also update the service definition. No manual
background scripts are needed.

On the first migration, stop any old `monitor_watcher.sh` process still left from
the previous configuration, or log out and back in.

## Checks

Run `python3 -B plugins/test_bar.py` for workspace, calendar, and audio command
tests. Rendering, device switching, and launchd behavior require a macOS session.
