import json
import os
from pathlib import Path
import subprocess
import unittest


class AudioTests(unittest.TestCase):
    def run_audio(self, *args, sinks=None, streams=None):
        return subprocess.run(
            ["bash", "-c", '''
                pactl() {
                    case "$*" in
                        '--format=json list sinks') printf '%s\\n' "$TEST_SINKS" ;;
                        '--format=json list sink-inputs') printf '%s\\n' "$TEST_STREAMS" ;;
                        'get-default-sink') printf '%s\\n' 'headset' ;;
                        *) printf '%s\\n' "$*" ;;
                    esac
                }
                export -f pactl
                bash "$@"
            ''', "test", str(Path(__file__).with_name("audio.sh")), *args],
            env={**os.environ, "TEST_SINKS": json.dumps(sinks or []),
                 "TEST_STREAMS": json.dumps(streams or [])},
            capture_output=True, text=True, timeout=5,
        )

    def test_snapshot_preserves_names_and_paused_streams(self):
        result = self.run_audio("snapshot", sinks=[
            {"index": 10, "name": "headset", "description": 'Headset "USB"'},
            {"index": 20, "name": "hdmi", "description": "Display"},
        ], streams=[{
            "index": 42, "properties": {"application.name": "Browser", "media.name": 'Song "title"\nLive'},
            "volume": {"left": {"value": 32768}, "right": {"value": 32768}},
            "mute": True, "corked": True,
        }])
        self.assertEqual(result.returncode, 0, result.stderr)
        data = json.loads(result.stdout)
        self.assertEqual([item["selected"] for item in data["outputs"]], [True, False])
        self.assertEqual(data["apps"], [{"id": 42, "name": "Browser", "title": 'Song "title"\nLive',
                                         "volume": 50, "muted": True, "paused": True}])

    def test_switching_output_moves_existing_playback(self):
        result = self.run_audio("output", "20", streams=[{"index": 42}, {"index": 43}])
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout.splitlines(), [
            "set-default-sink 20", "move-sink-input 42 20", "move-sink-input 43 20",
        ])

    def test_application_volume_and_mute_target_only_that_stream(self):
        result = self.run_audio("app-volume", "42", "75")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "set-sink-input-volume 42 75%\n")
        result = self.run_audio("app-mute", "42")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(result.stdout, "set-sink-input-mute 42 toggle\n")

    def test_invalid_ids_and_out_of_range_volume_fail_without_mutating_audio(self):
        for args in [("output", "bad"), ("app-mute", "1;true"),
                     ("app-volume", "42", "151"), ("app-volume", "42", "-1")]:
            with self.subTest(args=args):
                result = self.run_audio(*args)
                self.assertNotEqual(result.returncode, 0)
                self.assertEqual(result.stdout, "")


if __name__ == "__main__":
    unittest.main()
