#!/usr/bin/env bash

# Increase volume by 5%
pactl set-sink-volume @DEFAULT_SINK@ +5%

# Get current
current=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

# Cap at 100%
if [ "$current" -ge 100 ]; then
  pactl set-sink-volume @DEFAULT_SINK@ 100%
  current=100
  notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume " "
  exit 0
fi


# Show OSD that replaces itself
notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume "${current}"

