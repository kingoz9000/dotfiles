#!/usr/bin/env bash
set -euo pipefail 

icon_toggle_on="󰍭"
icon_toggle_off="󰍬"
status=$(pactl get-source-mute @DEFAULT_SOURCE@)

show_mode() {
  if [ "$status" == "Mute: no" ]; then
    echo "{\"text\":\"\",\"tooltip\":\"Mute Off\",\"class\":\"off\"}"
  else
    echo "{\"text\":\"$icon_toggle_on\",\"tooltip\":\"Mute On\",\"class\":\"on\"}"
  fi
}

toggle_mode() {
  if [ "$status" == "Mute: no" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:volume "$icon_toggle_on"

  else
    pactl set-source-mute @DEFAULT_SOURCE@ toggle
    notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:volume "$icon_toggle_off"
  fi

}

if [ "$1" = "toggle" ]; then
  toggle_mode
else
  show_mode
fi



