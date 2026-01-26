# AeroSpace Quick Guide

AeroSpace is an i3-like tiling window manager for macOS.

## Core Concepts

- **Workspaces**: Virtual desktops (1-9)
- **Hyper Key**: `Ctrl + Alt + Cmd` (used for most operations)
- **Tiling**: Windows automatically arrange in a tree structure
- **Focus**: Navigate between windows with `Alt + hjkl`

## Navigation

### Focus Windows
- `Alt + h` - Focus left
- `Alt + j` - Focus down
- `Alt + k` - Focus up
- `Alt + l` - Focus right
- **Note**: Use `Alt + Q` for @ symbol (since Alt+L is used for focus)

### Move Windows
- `Alt + Shift + h` - Move window left
- `Alt + Shift + j` - Move window down
- `Alt + Shift + k` - Move window up
- `Alt + Shift + l` - Move window right

## Workspaces

### Switch Workspace
- `Hyper + 1-9` - Switch to workspace 1-9

### Move Window to Workspace
- `Hyper + Shift + 1-9` - Move current window to workspace 1-9

### Navigate Between Workspaces
- `Hyper + Tab` - Switch to previous workspace

## Multi-Monitor

### Move Window Between Monitors
- `Hyper + h` - Move window to left monitor
- `Hyper + l` - Move window to right monitor

### Move Workspace to Another Monitor
- `Hyper + Shift + Tab` - Move workspace to next monitor

## Window Management

### Resize Windows
- `Hyper + j` - Increase window size by 50px
- `Hyper + k` - Decrease window size by 50px

### Layouts
- `Alt + Shift + ,` - Toggle tiles layout (horizontal/vertical)
- `Alt + Shift + .` - Toggle accordion layout (horizontal/vertical)

### Fullscreen
- `Hyper + Space` - Toggle fullscreen

### Open Terminal
- `Alt + Enter` - Open new WezTerm window

## Service Mode

Service mode provides advanced window manipulation.

### Enter Service Mode
- `Hyper + s` - Enter service mode

### In Service Mode
- `Esc` - Reload config and return to main mode
- `r` - Reset layout (flatten tree) and return to main mode
- `f` - Toggle floating/tiling and return to main mode
- `Backspace` - Close all windows except current and return to main mode

### Join Windows (in service mode)
- `Alt + Shift + h` - Join with window on left
- `Alt + Shift + j` - Join with window below
- `Alt + Shift + k` - Join with window above
- `Alt + Shift + l` - Join with window on right

## Tips

1. **Start simple**: Use workspaces 1-9 and basic navigation
2. **Hyper key is your friend**: Most operations use `Ctrl + Alt + Cmd`
3. **Service mode**: Use `Hyper + s` when you need to reorganize windows
4. **Sketchybar integration**: Active workspace shown in top bar
5. **Gaps**: 10px around windows, 34px at bottom

## Common Workflows

### Move app to specific workspace
1. Focus the window (`Alt + hjkl`)
2. `Hyper + Shift + [number]` to move it

### Switch workspace and bring window
1. Focus the window
2. `Hyper + Shift + [number]` to move window
3. `Hyper + [number]` to follow it

### Reset messy layout
1. `Hyper + s` to enter service mode
2. `r` to reset layout

## Workspace Assignment

These workspaces are assigned to specific monitors:
- Workspaces 1-2: Monitor 1
- Workspaces 3-4: Monitor 2
- Workspaces 5-6: Monitor 3
