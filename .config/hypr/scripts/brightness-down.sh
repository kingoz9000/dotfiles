#!/usr/bin/env bash

# Get current and max brightness
current=$(brightnessctl g)
max=$(brightnessctl m)
percent=$(( 100 * current / max ))

# Decide step size
if [ $percent -lt 10 ]; then
    step="1%-"
elif [ $percent -lt 30 ]; then
    step="2%-"
elif [ $percent -lt 70 ]; then
    step="5%-"
else
    step="10%-"
fi

# Apply brightness change
brightnessctl set "$step"

# Recalculate percentage after change
current=$(brightnessctl g)
percent=$(( 100 * current / max ))

# Cap at 0% (safety)
if [ $percent -lt 0 ]; then
    percent=0
    brightnessctl set 0%
fi

# Show popup that cancels previous
notify-send --app-name=brightness-osd -t 1000 -h string:x-canonical-private-synchronous:brightness "${percent}"

