#!/bin/bash

STATE_FILE="/tmp/airplane_mode_enabled"

icon_on="󰀝"     # Airplane icon (can customize)
icon_off="󰀞"    # Signal icon (can customize)

toggle_mode() {
  if [ -f "$STATE_FILE" ]; then
    # Turn airplane mode OFF
    sudo nmcli device connect wlan0
    rm -f "$STATE_FILE"
    notify-send "Airplane Mode OFF"
  else
    # Turn airplane mode ON
    sudo powertop --auto-tune >/dev/null 2>&1
    sudo nmcli device disconnect wlan0
    touch "$STATE_FILE"
    notify-send "Airplane Mode On"
  fi
}

show_mode() {
  if [ -f "$STATE_FILE" ]; then
    echo "{\"text\":\"$icon_on\",\"tooltip\":\"Airplane mode ON\",\"class\":\"on\"}"
  else
    echo "{\"text\":\"\",\"tooltip\":\"Airplane mode OFF\",\"class\":\"off\"}"
  fi
}

if [ "$1" = "toggle" ]; then
  toggle_mode
else
  show_mode
fi

