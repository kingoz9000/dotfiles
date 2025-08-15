#!/bin/bash

# Start scan silently in background
bluetoothctl scan on >/dev/null &

# Get only real "Device <MAC> <Name>" entries
mapfile -t lines < <(bluetoothctl --controller 74:13:EA:B7:66:C2 devices | grep -E '^Device ([0-9A-F]{2}:){5}[0-9A-F]{2} ')

if [[ ${#lines[@]} -eq 0 ]]; then
    notify-send "Bluetooth" "No valid devices found"
    exit 1
fi

# Build device map: name → MAC
declare -A device_map
names=()

for line in "${lines[@]}"; do
    mac=$(echo "$line" | awk '{print $2}')
    name=$(echo "$line" | cut -d' ' -f3-)
    # Skip garbage
    [[ -z "$name" || "$name" == "$mac" || "$name" == "/org/bluez/hci0" ]] && continue
    names+=("$name")
    device_map["$name"]="$mac"
done

# Show clean list in Wofi
selection=$(printf '%s\n' "${names[@]}" | sort -u | wofi --dmenu --prompt "Bluetooth Devices")

[[ -z "$selection" ]] && exit 0

mac="${device_map[$selection]}"

# Toggle connection
if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
    bluetoothctl disconnect "$mac"
    notify-send "Bluetooth" "Disconnected from $selection"
else
    bluetoothctl trust "$mac"
    bluetoothctl pair "$mac"
    bluetoothctl connect "$mac"
    notify-send "Bluetooth" "Connected to $selection"
fi

