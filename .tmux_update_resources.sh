#!/bin/bash

while true; do
    # 💾 RAM Usage (Always 4 digits, no MB)
    RAM_USAGE=$(free -m | grep "Mem:" | awk '{printf $3}')

    # 🌀 Fan Speed
    FAN_SPEED_RAW=$(cat /sys/class/hwmon/hwmon*/fan1_input)
    FAN_SPEED=$(printf "%04d" "$FAN_SPEED_RAW")
    # 🌡️ Temperature (Remove `°C`)
    TEMP=$(sensors | awk '/Package id 0/ {gsub(/\+|°C/, "", $4); print $4}')

    # 💻 CPU Usage
    CPU_USAGE=$(sh ~/scripts/tmux-scripts/cpu_usage.sh)
    # ✅ Write to /tmp/ files
    echo "$CPU_USAGE" > /tmp/tmux_cpu
    echo "$RAM_USAGE" > /tmp/tmux_ram
    echo "$FAN_SPEED" > /tmp/tmux_fan
    echo "$TEMP" > /tmp/tmux_temp

    # Refresh every 5 seconds
    sleep 5
done
