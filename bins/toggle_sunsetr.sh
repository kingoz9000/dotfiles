#!/usr/bin/env bash
set -euo pipefail 
STATE_DIR="$HOME/.cache/sunsetr" 
STATE_FILE="$STATE_DIR/state.flag" 
state=$(cat "$STATE_FILE")


if [ -f "$STATE_FILE" ]; then
  if [ "$state" == "on" ]; then
    echo "off" > "$STATE_FILE"
    pkill sunsetr
    notify-send "Sunsetr Off"
  elif [ "$state" == "off" ]; then
    echo "on" > "$STATE_FILE"
    sunsetr reload
    notify-send "Sunsetr On"
  else
    echo "HEEELP"
    notify-send "Something went wrong." "Check ~/.cache/sunsetr"
  fi
fi

