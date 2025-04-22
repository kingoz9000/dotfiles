#!/bin/bash

get_cpu_usage() {
    # First snapshot
    read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
    total1=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle1=$idle

    sleep 1

    # Second snapshot
    read cpu user nice system idle iowait irq softirq steal guest < /proc/stat
    total2=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle2=$idle

    total_diff=$((total2 - total1))
    idle_diff=$((idle2 - idle1))

    usage=$(( (100 * (total_diff - idle_diff)) / total_diff ))

    printf "%02d" "$usage"
}

while true; do
    # 💾 RAM Usage (Always 4 digits, no MB)
    RAM_USAGE=$(free -m | awk '/Mem:/ {printf "%04d", $3}')

    # 🌀 Fan Speed
    FAN_SPEED_RAW=$(awk '{printf "%04d\n", $1}' /sys/class/hwmon/hwmon*/fan1_input)
    FAN_SPEED=$(printf "%04d" "$FAN_SPEED_RAW")

    # 🌡️ Temperature (Remove `°C`)
    TEMP=$(sensors | awk '/Package id 0/ {gsub(/\+|°C/, "", $4); print $4}')

    # 💻 CPU Usage
    CPU_USAGE=$(get_cpu_usage)


    # ✅ Write to /tmp/ files (Ensures files are actually written)
    echo "$CPU_USAGE" > /tmp/tmux_cpu
    echo "$RAM_USAGE" > /tmp/tmux_ram
    echo "$FAN_SPEED" > /tmp/tmux_fan
    echo "$TEMP" > /tmp/tmux_temp


    sleep 5
done
