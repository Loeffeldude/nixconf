import json
import os
from pathlib import Path
import subprocess
import unittest


class WorkspaceTests(unittest.TestCase):
    def snapshot(self, workspaces, clients, active=1):
        monitors = [
            {"name": "DP-2", "activeWorkspace": {"id": active}, "specialWorkspace": {"id": 0}},
            {"name": "HDMI-A-1", "activeWorkspace": {"id": 9}, "specialWorkspace": {"id": 0}},
        ]
        result = subprocess.run(
            ["jq", "-cn", "--argjson", "monitors", json.dumps(monitors),
             "--argjson", "workspaces", json.dumps(workspaces),
             "--argjson", "clients", json.dumps(clients),
             "-f", str(Path(__file__).with_name("workspaces.jq"))],
            check=True, capture_output=True, text=True, timeout=5,
        )
        return json.loads(result.stdout)

    def test_high_numbered_workspace_follows_its_monitor(self):
        workspace = {"id": 42, "name": "42", "monitor": "DP-2"}
        clients = [{"workspace": {"id": 42}, "class": "firefox", "title": "Browser"}]
        self.assertEqual([ws["id"] for ws in self.snapshot([workspace], clients)["DP-2"]], [42])
        workspace["monitor"] = "HDMI-A-1"
        result = self.snapshot([workspace], clients)
        self.assertEqual(result["DP-2"], [])
        self.assertEqual([ws["id"] for ws in result["HDMI-A-1"]], [42])

    def test_only_active_empty_workspace_stays_visible(self):
        workspaces = [{"id": i, "name": str(i), "monitor": "DP-2"} for i in [1, 2]]
        result = self.snapshot(workspaces, [])
        self.assertEqual([ws["id"] for ws in result["DP-2"]], [1])
        self.assertTrue(result["DP-2"][0]["active"])
        self.assertFalse(result["DP-2"][0]["occupied"])

    def test_named_and_special_workspaces_are_reachable(self):
        workspaces = [
            {"id": -1337, "name": "build", "monitor": "DP-2"},
            {"id": -99, "name": "special:scratch", "monitor": "DP-2"},
        ]
        clients = [{"workspace": {"id": ws["id"]}, "class": "kitty", "title": "Terminal"}
                   for ws in workspaces]
        result = self.snapshot(workspaces, clients)["DP-2"]
        self.assertEqual([(ws["name"], ws["special"]) for ws in result],
                         [("build", False), ("scratch", True)])

    def test_titles_are_preserved_and_apps_are_grouped(self):
        title = 'A "quoted" title\nwith a newline | and backslash \\'
        workspace = {"id": 12, "name": "12", "monitor": "DP-2"}
        client = {"workspace": {"id": 12}, "class": "firefox", "title": title}
        result = self.snapshot([workspace], [client, client])["DP-2"][0]
        self.assertIn(title, result["tooltip"])
        self.assertEqual(len(result["apps"]), 1)
        self.assertEqual(result["apps"][0]["count"], 2)

    def test_click_dispatches_numeric_named_and_special_workspaces(self):
        for workspace_id, name, expected in [
            (42, "42", "workspace\n42\n"),
            (-1337, "build", "workspace\nname:build\n"),
            (-99, "special:scratch", "togglespecialworkspace\nscratch\n"),
        ]:
            with self.subTest(name=name):
                result = self.dispatch(str(workspace_id), [{"id": workspace_id, "name": name}])
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(result.stdout, expected)

    def test_click_rejects_invalid_or_removed_workspace(self):
        for workspace_id in ["not-an-id", "42"]:
            with self.subTest(workspace_id=workspace_id):
                result = self.dispatch(workspace_id, [])
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")

    def dispatch(self, workspace_id, workspaces):
        return subprocess.run(
            ["bash", "-c", '''
                hyprctl() {
                    if [[ $1 == -j ]]; then
                        printf '%s\\n' "$TEST_WORKSPACES"
                    else
                        printf '%s\\n' "$2" "$3"
                    fi
                }
                export -f hyprctl
                bash "$1" "$2"
            ''', "test", str(Path(__file__).with_name("dispatch.sh")), workspace_id],
            env={**os.environ, "TEST_WORKSPACES": json.dumps(workspaces)},
            capture_output=True, text=True, timeout=5,
        )


if __name__ == "__main__":
    unittest.main()
