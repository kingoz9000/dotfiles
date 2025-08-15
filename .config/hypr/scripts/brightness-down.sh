#!/usr/bin/env bash

# Decrease brightness by 5%
brightnessctl set 5%-

# Get current & max
current=$(brightnessctl g)
max=$(brightnessctl m)

# Calculate percentage
percent=$(( 100 * current / max ))
icon=""

# Cap at 0% (safe)
if [ "$percent" -lt 0 ]; then
  percent=0
  brightnessctl set 0%
  notify-send --app-name=brightness-osd -t 1000 -h string:x-canonical-private-synchronous:brightness "󰃞 "
fi


# Show popup that cancels previous
notify-send --app-name=brightness-osd -t 1000 -h string:x-canonical-private-synchronous:brightness "${percent}"

