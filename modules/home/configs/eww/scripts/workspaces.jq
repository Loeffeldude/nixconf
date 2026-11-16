def app_icon:
  ascii_downcase |
  if test("firefox") then ""
  elif test("chrom|brave") then ""
  elif test("wezterm|kitty|alacritty|foot|wterm") then ""
  elif test("code|codium") then "󰨞"
  elif test("vim") then ""
  elif test("spotify") then ""
  elif test("discord|vesktop") then "󰙯"
  elif test("slack") then "󰒱"
  elif test("thunar|nautilus|dolphin|nemo") then ""
  elif test("steam") then "󰓓"
  else "󰣆" end;

$monitors | map(. as $monitor | {
  key: .name,
  value: [$workspaces[] | select(.monitor == $monitor.name) | . as $ws |
    [$clients[] | select(.workspace.id == $ws.id)] as $windows |
    {
      id: .id,
      name: (.name | sub("^special:"; "")),
      special: (.name | startswith("special:")),
      active: (.id == $monitor.activeWorkspace.id or .id == $monitor.specialWorkspace.id),
      occupied: ($windows | length > 0),
      tooltip: ([.name] + [$windows[] | .class + ": " + .title] | join("\n")),
      apps: ($windows | group_by(.class) | map({
        icon: (.[0].class | app_icon),
        name: .[0].class,
        count: length
      }))
    } | select(.occupied or .active)] | sort_by(.special, .id)
}) | from_entries
