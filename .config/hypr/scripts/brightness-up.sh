#!/usr/bin/env bash

# Increase brightness by 5%
brightnessctl set +5%

# Get current & max
current=$(brightnessctl g)
max=$(brightnessctl m)

# Calculate percentage
percent=$(( 100 * current / max ))

# Cap at 100% (optional but safe)
if [ "$percent" -ge 100 ]; then
  percent=100
  brightnessctl set 100%
  notify-send --app-name=brightness-osd -t 1000 -h string:x-canonical-private-synchronous:brightness "󰃠 "
  exit 0
fi


# Show popup that cancels previous
notify-send --app-name=brightness-osd -t 1000 -h string:x-canonical-private-synchronous:brightness "${percent}"

