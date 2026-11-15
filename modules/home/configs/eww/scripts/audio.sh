#!/usr/bin/env bash
set -euo pipefail
export LC_ALL=C.UTF-8

case "${1:?Expected snapshot, output, app-volume, or app-mute}" in
  snapshot)
    sinks=$(pactl --format=json list sinks)
    streams=$(pactl --format=json list sink-inputs)
    default=$(pactl get-default-sink)
    jq -cn --argjson sinks "$sinks" --argjson streams "$streams" --arg default "$default" '
      {
        outputs: [$sinks[] | {
          id: .index, name: .description, selected: (.name == $default)
        }],
        apps: [$streams[] | {
          id: .index,
          name: (.properties["application.name"] // .properties["application.process.binary"] // "Audio stream"),
          title: (.properties["media.name"] // ""),
          volume: ([.volume[].value] | max / 65536 * 100 | round),
          muted: .mute,
          paused: .corked
        }] | sort_by(.name, .id)
      }'
    ;;
  output)
    [[ ${2-} =~ ^[0-9]+$ ]]
    pactl set-default-sink "$2"
    streams=$(pactl --format=json list sink-inputs)
    while IFS= read -r id; do
      pactl move-sink-input "$id" "$2"
    done < <(jq -r '.[].index' <<< "$streams")
    ;;
  app-volume)
    [[ ${2-} =~ ^[0-9]+$ && ${3-} =~ ^[0-9]+([.][0-9]+)?$ ]]
    jq -en --argjson value "$3" '$value >= 0 and $value <= 150' > /dev/null
    pactl set-sink-input-volume "$2" "$3%"
    ;;
  app-mute)
    [[ ${2-} =~ ^[0-9]+$ ]]
    pactl set-sink-input-mute "$2" toggle
    ;;
  *) exit 2 ;;
esac
