#!/usr/bin/env bash

current=$(pactl get-sink-mute @DEFAULT_SINK@)
if [ "$current" = "Mute: yes" ]; then
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  percent=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1 | tr -d '%')

  if [ "$percent" -ge 100 ]; then
    notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume " "
    exit 0
  fi

  if [ "$percent" -le 0 ]; then
    notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume " "
    exit 0
  fi


  notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume "${percent}"


else
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  notify-send --app-name=volume-osd -t 1000 -h string:x-canonical-private-synchronous:volume "󰖁"

fi


