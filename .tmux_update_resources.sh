#!/bin/bash

while true; do
    # 💾 RAM Usage (Always 4 digits, no MB)
    RAM_USAGE=$(free -m | awk '/Mem:/ {printf "%04d", $3}')

    # 🌀 Fan Speed
    FAN_SPEED_RAW=$(awk '{printf "%04d\n", $1}' /sys/class/hwmon/hwmon*/fan1_input)
    FAN_SPEED=$(printf "%04d" "$FAN_SPEED_RAW")

    # 🌡️ Temperature (Remove `°C`)
    TEMP=$(sensors | awk '/Package id 0/ {gsub(/\+|°C/, "", $4); print $4}')

    # 💻 CPU Usage
    CPU_USAGE=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%02d", usage}')


    # ✅ Write to /tmp/ files (Ensures files are actually written)
    echo "$CPU_USAGE" > /tmp/tmux_cpu
    echo "$RAM_USAGE" > /tmp/tmux_ram
    echo "$FAN_SPEED" > /tmp/tmux_fan
    echo "$TEMP" > /tmp/tmux_temp


    sleep 5
done
