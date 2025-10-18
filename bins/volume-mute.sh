#!/usr/bin/env bash
set -euo pipefail 

current=$(pactl get-sink-mute @DEFAULT_SINK@)

show_mode() {
  if [ "$current" = "Mute: no" ]; then
    echo "{\"text\":\"\",\"tooltip\":\"Mute Off\",\"class\":\"off\"}"
  else
    echo "{\"text\":\"󰖁\",\"tooltip\":\"Mute On\",\"class\":\"on\"}"
  fi
}

toggle_mode() {
  local LED="/sys/class/leds/platform::mute/brightness"
  if [ "$current" = "Mute: yes" ]; then
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    printf 0 > "$LED"
    percent=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

    if [ "$percent" -ge 100 ]; then
      notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:hardware-control " "
      exit 0
    fi

    if [ "$percent" -le 0 ]; then
      notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:hardware-control " "
      exit 0
    fi


    notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:hardware-control "${percent}"


  else
    printf 1 > "$LED"
    pactl set-sink-mute @DEFAULT_SINK@ toggle
    notify-send --app-name=hardware-control -t 1000 -h string:x-canonical-private-synchronous:hardware-control "󰖁"

  fi
}


if [ "$1" = "toggle" ]; then
  toggle_mode
else
  show_mode
fi
