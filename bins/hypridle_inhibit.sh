#!/bin/bash

STATE_FILE="/tmp/hypridle_inhibit"
icon_on=""
icon_off=""

show_mode() {
  if [[ -f "$STATE_FILE" ]]; then
  echo "{\"text\":\"$icon_on\",\"tooltip\":\"Inhibit On\",\"class\":\"on\"}"
  else
  echo "{\"text\":\"\",\"tooltip\":\"Inhibit Off\",\"class\":\"off\"}"
  fi
}

toggle_mode() {
    if [[ -f "$STATE_FILE" ]]; then
        rm "$STATE_FILE"
        notify-send "HyprIdle Inhibit Off"
    else
        touch "$STATE_FILE"
        notify-send "HyprIdle Inhibit On"
    fi
  }


if [[ "$1" == "toggle" ]]; then
  toggle_mode
else
  show_mode
fi


