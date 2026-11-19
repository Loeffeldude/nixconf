import json
import os
import shlex
import unittest
from unittest.mock import patch

import bar


class WorkspaceTests(unittest.TestCase):
    def test_occupied_and_visible_workspaces_follow_appkit_display_ids(self):
        spaces = [
            {"workspace": "42", "workspace-is-visible": False, "monitor-id": 2, "monitor-appkit-nsscreen-screens-id": 3},
            {"workspace": "work", "workspace-is-visible": True, "monitor-id": 1, "monitor-appkit-nsscreen-screens-id": 1},
            {"workspace": "2", "workspace-is-visible": False, "monitor-id": 1, "monitor-appkit-nsscreen-screens-id": 1},
        ]
        result = bar.workspace_items(spaces, [{"workspace": "42", "app-name": "Firefox"}])
        self.assertEqual([(ws["name"], ws["display"], ws["active"]) for ws in result],
                         [("work", 1, True), ("42", 3, False)])

    def test_each_visible_monitor_workspace_is_highlighted(self):
        spaces = [{"workspace": str(i), "workspace-is-visible": True, "monitor-id": i,
                   "monitor-appkit-nsscreen-screens-id": i} for i in [1, 2]]
        self.assertEqual([ws["active"] for ws in bar.workspace_items(spaces, [])], [True, True])

    def test_app_counts_are_compact_and_workspace_names_are_shell_safe(self):
        name = "work's $(touch bad)"
        spaces = [{"workspace": name, "workspace-is-visible": True, "monitor-id": 1,
                   "monitor-appkit-nsscreen-screens-id": 2}]
        windows = [{"workspace": name, "app-name": "Firefox"}] * 2
        calls = []

        def query(*args):
            calls.append(args)
            if args == ("--query", "bar"):
                return '{"items": ["space.obsolete"]}'
            return ""

        with patch.object(bar, "run", side_effect=[json.dumps(spaces), json.dumps(windows)]), \
                patch.object(bar, "sbar", side_effect=query):
            bar.workspaces()
        self.assertIn(("--remove", "space.obsolete"), calls)
        update = next(args for args in calls if args[0] == "--set" and args[1].startswith("space."))
        self.assertIn("label=" + bar.app_icon("Firefox") + " 2", update)
        click = next(arg.removeprefix("click_script=") for arg in update if arg.startswith("click_script="))
        self.assertEqual(shlex.split(click), ["aerospace", "workspace", name])

    def test_monitor_groups_are_shown_on_all_bars_and_stale_groups_are_removed(self):
        spaces = [
            {"workspace": "1", "workspace-is-visible": True, "monitor-id": 1, "monitor-appkit-nsscreen-screens-id": 2},
            {"workspace": "42", "workspace-is-visible": True, "monitor-id": 2, "monitor-appkit-nsscreen-screens-id": 1},
        ]
        calls = []

        def query(*args):
            calls.append(args)
            if args == ("--query", "bar"):
                return '{"items": ["workspace.monitor.3", "space.stale"]}'
            return ""

        with patch.object(bar, "run", side_effect=[json.dumps(spaces), "[]"]), \
                patch.object(bar, "sbar", side_effect=query):
            bar.workspaces()
        self.assertIn(("--remove", "workspace.monitor.3"), calls)
        self.assertIn(("--remove", "space.stale"), calls)
        updates = [args for args in calls if args[0] == "--set"]
        self.assertEqual([args[1] for args in updates],
                         ["workspace.monitor.2", "space.31", "workspace.monitor.1", "space.3432"])
        for args in updates:
            self.assertIn("display=0", args)
            self.assertEqual(args[-4:], ("--move", args[1], "before", "workspace.anchor"))

    def test_rearranging_monitors_reorders_groups_without_changing_their_identity(self):
        spaces = [
            {"workspace": name, "workspace-is-visible": True,
             "monitor-id": order, "monitor-appkit-nsscreen-screens-id": display}
            for name, order, display in [("10", 1, 3), ("2", 1, 3), ("1", 2, 1)]
        ]
        result = bar.workspace_items(spaces, [])
        self.assertEqual([(ws["name"], ws["display"]) for ws in result],
                         [("2", 3), ("10", 3), ("1", 1)])
        for ws in spaces:
            ws["monitor-id"] = 3 - ws["monitor-id"]
        result = bar.workspace_items(spaces, [])
        self.assertEqual([(ws["name"], ws["display"]) for ws in result],
                         [("1", 1), ("2", 3), ("10", 3)])


class PopupTests(unittest.TestCase):
    def test_calendar_handles_leap_years_and_monday_first(self):
        rows = bar.calendar_rows(2024, 2)
        self.assertEqual(rows[0], "             1   2   3   4")
        self.assertEqual(" ".join(rows).split(), [str(i) for i in range(1, 30)])

    def test_opening_calendar_closes_the_other_popups(self):
        with patch.object(bar, "sbar", return_value='{"popup":{"drawing":"off"}}') as sbar, \
                patch.object(bar, "show_calendar") as calendar:
            bar.toggle("clock")
        self.assertIn("volume", sbar.call_args_list[1].args)
        calendar.assert_called_once()
        self.assertEqual(sbar.call_args_list[-1].args, ("--set", "clock", "popup.drawing=on"))

    def test_clicking_open_popup_closes_it_without_rebuilding(self):
        with patch.object(bar, "sbar", return_value='{"popup":{"drawing":"on"}}'), \
                patch.object(bar, "show_calendar") as calendar:
            bar.toggle("clock")
        calendar.assert_not_called()

    def test_volume_update_marks_the_current_output_and_lists_all_devices(self):
        responses = ["75,false", '{"id":"2","name":"Speakers"}\n{"id":"3","name":"Headset"}',
                     '{"id":"3","name":"Headset"}']
        with patch.object(bar, "run", side_effect=responses), \
                patch.object(bar, "sbar", return_value='{"popup":{"drawing":"on"}}'), \
                patch.object(bar, "popup_row") as row:
            bar.audio()
        self.assertEqual(row.call_count, 2)
        self.assertEqual(row.call_args_list[0].kwargs["label.color"], bar.FG)
        self.assertEqual(row.call_args_list[1].kwargs["label.color"], bar.ACCENT)
        self.assertEqual(shlex.split(row.call_args_list[1].kwargs["click_script"])[-2:], ["output", "3"])

    def test_invalid_volume_is_rejected_before_calling_macos(self):
        with patch.object(bar.sys, "argv", ["bar.py", "set-volume"]), \
                patch.dict(os.environ, {"PERCENTAGE": "101"}), patch.object(bar, "run") as run:
            with self.assertRaises(ValueError):
                bar.main()
        run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
