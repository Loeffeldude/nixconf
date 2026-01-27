# eww Configuration

This is a conversion of your Waybar configuration to eww.

## Structure

- `eww.yuck` - Main configuration file with widget definitions
- `eww.scss` - Stylesheet (converted from Waybar CSS)
- `scripts/` - Helper scripts for dynamic data

## Features

- Hyprland workspace indicator with active/urgent states
- Clock widget
- MPRIS media player info (requires `playerctl`)
- CPU and memory usage monitors
- Battery indicator with charging/warning/critical states
- Volume control (WirePlumber via `wpctl`)
- System tray

## Dependencies

Make sure you have these installed:
- `eww` (elkowar's wacky widgets)
- `socat` (for Hyprland event monitoring)
- `jq` (for JSON processing)
- `playerctl` (for media control)
- `wpctl` (WirePlumber CLI, usually comes with wireplumber)

## Usage

Start eww:
```bash
eww daemon
eww open bar
```

Reload after changes:
```bash
eww reload
```

## Differences from Waybar

1. **Taskbar**: eww doesn't have a built-in taskbar widget like Waybar. You'd need to implement this manually with custom scripts if needed.

2. **Dynamic updates**: eww uses polling (`defpoll`) and listening (`deflisten`) rather than Waybar's built-in update mechanism. The scripts handle real-time updates via Hyprland's socket.

3. **Calendar**: The calendar popup from Waybar's clock isn't implemented yet. You can add this with a separate window widget that opens on clock click.

4. **Styling**: eww uses SCSS instead of CSS. The conversion maintains the same visual style.

## Customization

- Adjust polling intervals in `eww.yuck` (e.g., `:interval "2s"`)
- Modify colors and styles in `eww.scss`
- Edit widget layouts in the `defwidget` sections
- Add or remove modules as needed

## NixOS Integration

To integrate with your NixOS configuration, add:

```nix
programs.eww = {
  enable = true;
  configDir = ./configs/eww;
};
```
