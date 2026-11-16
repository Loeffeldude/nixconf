import calendar
from collections import Counter
from datetime import date, datetime
import json
import os
from pathlib import Path
import shlex
import subprocess
import sys


BG = "0xff101010"
FG = "0xffece7e1"
MUTED = "0xff96918b"
ACCENT = "0xffde935f"
BORDER = "0xff292725"
ACTIVE = "0xff302319"
HERE = Path(__file__).resolve().parent


def run(*args):
    return subprocess.check_output(args, text=True, timeout=15).strip()


def sbar(*args):
    return run("sketchybar", *map(str, args))


def command(*args):
    return shlex.join([sys.executable, str(HERE / "bar.py"), *map(str, args)])


def item(name, position, **properties):
    sbar("--add", "item", name, position, "--set", name,
         *(f"{key}={value}" for key, value in properties.items()))


def app_icon(name):
    name = name.lower()
    for pattern, icon in [("firefox", ""), ("safari", ""), ("chrome", ""),
                          ("wezterm", ""), ("terminal", ""), ("iterm", ""),
                          ("code", "󰨞"), ("spotify", ""), ("discord", "󰙯"),
                          ("slack", "󰒱"), ("finder", ""), ("teams", "󰊻")]:
        if pattern in name:
            return icon
    return "󰣆"


def workspace_items(workspaces, windows):
    result = []
    for ws in workspaces:
        name = ws["workspace"]
        apps = Counter(window["app-name"] for window in windows if window["workspace"] == name)
        visible = str(ws["workspace-is-visible"]).lower() == "true"
        if not visible and not apps:
            continue
        icons = "  ".join(app_icon(app) + (f" {count}" if count > 1 else "")
                          for app, count in sorted(apps.items()))
        result.append({"id": "space." + name.encode().hex(), "name": name,
                       "display": ws["monitor-appkit-nsscreen-screens-id"],
                       "active": visible, "icons": icons})
    return sorted(result, key=lambda ws: (not ws["name"].isdigit(),
                                         int(ws["name"]) if ws["name"].isdigit() else ws["name"]))


def workspaces():
    spaces = json.loads(run("aerospace", "list-workspaces", "--all", "--json", "--format",
                           "%{workspace} %{workspace-is-visible} %{monitor-appkit-nsscreen-screens-id}"))
    windows = json.loads(run("aerospace", "list-windows", "--all", "--json", "--format",
                            "%{workspace} %{app-name}"))
    desired = workspace_items(spaces, windows)
    existing = {name for name in json.loads(sbar("--query", "bar"))["items"]
                if name.startswith("space.")}
    for name in existing - {ws["id"] for ws in desired}:
        sbar("--remove", name)
    for ws in desired:
        if ws["id"] not in existing:
            item(ws["id"], "left")
        sbar("--set", ws["id"], f"display={ws['display']}",
             f"icon={ws['name']}", f"label={ws['icons']}",
             f"icon.color={ACCENT if ws['active'] else MUTED}",
             f"label.color={ACCENT if ws['active'] else MUTED}",
             "icon.font=SF Pro:Semibold:12.0", "label.font=Hack Nerd Font:Regular:13.0",
             f"background.drawing={'on' if ws['active'] else 'off'}",
             f"background.color={ACTIVE}", "background.corner_radius=7", "background.height=28",
             "click_script=" + shlex.join(["aerospace", "workspace", ws["name"]]),
             "--move", ws["id"], "before", "workspace.anchor")


def dismiss():
    sbar("--set", "clock", "popup.drawing=off", "--set", "volume", "popup.drawing=off",
         "--set", "apple.logo", "popup.drawing=off")


def popup_row(name, parent, text, width, **properties):
    item(name, "popup." + parent, **{
        "label": text, "width": width, "icon.drawing": "off", "label.color": FG,
        "label.padding_left": 22, "label.padding_right": 22, "label.width": width - 44,
        "background.drawing": "off",
        **properties,
    })


def popup_style(parent):
    sbar("--set", parent, "popup.align=right", "popup.height=32", "popup.y_offset=6",
         "popup.blur_radius=0", f"popup.background.color={BG}",
         "popup.background.border_width=1", f"popup.background.border_color={BORDER}",
         "popup.background.corner_radius=0", "popup.background.drawing=on")


def calendar_rows(year, month):
    return ["  ".join(f"{day:2}" if day else "  " for day in week)
            for week in calendar.Calendar(firstweekday=0).monthdayscalendar(year, month)]


def show_calendar(year, month):
    sbar("--remove", "/calendar\\..*/")
    today = date.today()
    popup_row("calendar.title", "clock", "Calendar", 364, **{"label.font": "SF Pro:Semibold:14.0"})
    popup_row("calendar.today", "clock", today.strftime("%a, %d %b"), 364, **{"label.color": MUTED})
    previous = date(year - (month == 1), 12 if month == 1 else month - 1, 1)
    following = date(year + (month == 12), 1 if month == 12 else month + 1, 1)
    popup_row("calendar.month", "clock", f"{calendar.month_name[month]} {year}", 364,
              **{"label.color": ACCENT, "label.align": "center"})
    popup_row("calendar.previous", "clock", "< Previous month", 364,
              click_script=command("calendar", previous.year, previous.month))
    popup_row("calendar.next", "clock", "Next month >", 364,
              click_script=command("calendar", following.year, following.month))
    popup_row("calendar.weekdays", "clock", "Mo  Tu  We  Th  Fr  Sa  Su", 364,
              **{"label.font": "Hack Nerd Font:Regular:13.0", "label.color": MUTED, "label.align": "center"})
    for index, row in enumerate(calendar_rows(year, month)):
        popup_row(f"calendar.week.{index}", "clock", row, 364,
                  **{"label.font": "Hack Nerd Font:Regular:13.0", "label.align": "center"})
    popup_row("calendar.close", "clock", "Close", 364, **{"label.color": MUTED},
              click_script=command("dismiss"))


def audio():
    settings = run("osascript", "-e", "set v to get volume settings",
                   "-e", 'return (output volume of v as string) & "," & (output muted of v as string)')
    level, muted = settings.split(",")
    level = int(level)
    icon = "󰖁" if muted == "true" else "󰕾" if level > 66 else "󰖀" if level > 33 else "󰕿"
    sbar("--set", "volume", f"icon={icon}", f"label={level}%",
         f"icon.color={MUTED if muted == 'true' else FG}",
         "--set", "audio.slider", f"slider.percentage={level}", f"label={level}%",
         "--set", "audio.mute", f"label={'Unmute' if muted == 'true' else 'Mute'}",
         f"label.color={ACCENT if muted == 'true' else MUTED}")
    if json.loads(sbar("--query", "volume"))["popup"]["drawing"] != "on":
        return
    devices = [json.loads(line) for line in run("SwitchAudioSource", "-a", "-t", "output", "-f", "json").splitlines()]
    current = json.loads(run("SwitchAudioSource", "-c", "-t", "output", "-f", "json"))
    sbar("--remove", "/audio\\.output\\..*/")
    for index, device in enumerate(devices):
        selected = device["id"] == current["id"]
        popup_row(f"audio.output.{index}", "volume", device["name"], 800,
                  **{"label.color": ACCENT if selected else FG},
                  click_script=command("output", device["id"]))
    sbar("--move", "audio.close", "after", f"audio.output.{len(devices) - 1}" if devices else "audio.outputs")


def toggle(parent):
    opened = json.loads(sbar("--query", parent))["popup"]["drawing"] == "on"
    dismiss()
    if opened:
        return
    if parent == "clock":
        today = date.today()
        show_calendar(today.year, today.month)
    sbar("--set", parent, "popup.drawing=on")
    if parent == "volume":
        audio()


def setup():
    sbar("--bar", "height=40", "position=top", "padding_left=12", "padding_right=12",
         f"color={BG}", "blur_radius=0", "shadow=off", "corner_radius=0",
         "border_width=1", f"border_color={BORDER}", "display=all")
    sbar("--default", "icon.font=Hack Nerd Font:Regular:13.0", f"icon.color={FG}",
         "icon.padding_left=10", "icon.padding_right=4", "label.font=SF Pro:Regular:12.0",
         f"label.color={FG}", "label.padding_left=4", "label.padding_right=10",
         "padding_left=2", "padding_right=2", "background.drawing=off", "background.border_width=0",
         "background.corner_radius=0", "blur_radius=0", "background.shadow.drawing=off")
    subprocess.run(["bash", str(HERE / "apple_menu.sh")], check=True,
                   env={**os.environ, "FG": FG, "BG": BG, "ACCENT": ACCENT})
    item("workspace.anchor", "left", drawing="off", updates="on", update_freq=2,
         script=command("workspaces"))
    sbar("--add", "event", "aerospace_workspace_change", "--subscribe", "workspace.anchor",
         "aerospace_workspace_change", "display_change", "space_windows_change", "system_woke")
    item("popup.dismiss", "left", drawing="off", updates="on", script=command("dismiss"))
    sbar("--subscribe", "popup.dismiss", "mouse.exited.global", "front_app_switched", "system_will_sleep")
    item("clock", "right", **{"icon.drawing": "off", "label.font": "SF Pro:Semibold:12.0",
                               "update_freq": 10, "script": command("clock"),
                               "click_script": command("toggle", "clock")})
    item("volume", "right", script=command("audio"), update_freq=2,
         click_script=command("toggle", "volume"))
    sbar("--subscribe", "volume", "volume_change", "system_woke")
    for name, icon, frequency in [("battery", "", 30), ("ram", "", 2), ("cpu", "󰻠", 2)]:
        item(name, "right", icon=icon, update_freq=frequency,
             **{"icon.color": MUTED, "label.color": MUTED},
             script=shlex.join(["bash", str(HERE / f"{name}.sh")]))
    sbar("--subscribe", "battery", "system_woke", "power_source_change")
    item("media", "center", **{"label.max_chars": 24, "label.color": MUTED, "icon.drawing": "off",
                                "scroll_texts": "off", "update_freq": 5,
                                "script": shlex.join(["bash", str(HERE / "media.sh")])})
    sbar("--subscribe", "media", "media_change")
    popup_style("clock")
    popup_style("volume")
    popup_row("audio.title", "volume", "Sound", 800, **{"label.font": "SF Pro:Semibold:14.0"})
    popup_row("audio.subtitle", "volume", "Playback and output devices", 800, **{"label.color": MUTED})
    popup_row("audio.mute", "volume", "Mute", 800, click_script=command("mute"))
    sbar("--add", "slider", "audio.slider", "popup.volume", 680, "--set", "audio.slider",
         "width=800", "icon.drawing=off", f"slider.highlight_color={ACCENT}",
         "slider.background.height=4", f"slider.background.color={BORDER}",
         "slider.background.corner_radius=0", "slider.knob=●", f"slider.knob.color={FG}",
         "script=" + command("set-volume"), "--subscribe", "audio.slider", "mouse.clicked")
    popup_row("audio.outputs", "volume", "OUTPUT DEVICES", 800, **{"label.color": MUTED})
    popup_row("audio.close", "volume", "Close", 800, **{"label.color": MUTED}, click_script=command("dismiss"))
    sbar("--update")


def main():
    action = sys.argv[1]
    if action == "setup":
        setup()
    elif action == "workspaces":
        workspaces()
    elif action == "clock":
        sbar("--set", "clock", "label=" + datetime.now().strftime("%a, %d %b  %H:%M"))
    elif action == "calendar":
        show_calendar(int(sys.argv[2]), int(sys.argv[3]))
    elif action == "toggle":
        toggle(sys.argv[2])
    elif action == "dismiss":
        dismiss()
    elif action == "audio":
        audio()
    elif action == "mute":
        run("osascript", "-e", "set volume output muted not (output muted of (get volume settings))")
        audio()
    elif action == "set-volume":
        percentage = int(float(os.environ["PERCENTAGE"]))
        if not 0 <= percentage <= 100:
            raise ValueError("Volume must be between 0 and 100")
        run("osascript", "-e", f"set volume output volume {percentage}")
        audio()
    elif action == "output":
        run("SwitchAudioSource", "-t", "output", "-i", str(int(sys.argv[2])))
        audio()
    else:
        raise ValueError(f"Unknown action: {action}")


if __name__ == "__main__":
    main()
