#!/usr/bin/env bash
set -euo pipefail

get_volume() {
  pactl get-sink-volume @DEFAULT_SINK@ \
    | grep -oE '[0-9]+%' \
    | head -1 \
    | tr -d '%'
}

show_osd() {
  local v="$1"
  local msg

  if [ "$v" -ge 100 ]; then
    msg=" "     # icon for max
  elif [ "$v" -le 0 ]; then
    msg=" "     # icon for mute
  else
    msg="$v"
  fi

  notify-send --app-name=hardware-control -t 1000 \
    -h string:x-canonical-private-synchronous:hardware-control \
    "$msg"
}

cap_volume() {
  local v
  v="$(get_volume)"
  if [ "$v" -gt 100 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ 100%
    v=100
  elif [ "$v" -lt 0 ]; then
    pactl set-sink-volume @DEFAULT_SINK@ 0%
    v=0
  fi
  echo "$v"
}

up() {
  pactl set-sink-volume @DEFAULT_SINK@ +5%
  local v
  v="$(cap_volume)"
  show_osd "$v"
}

down() {
  pactl set-sink-volume @DEFAULT_SINK@ -5%
  local v
  v="$(cap_volume)"
  show_osd "$v"
}

show_mode() {
  echo "$(get_volume)"
}

case "${1-}" in
  up) up ;;
  down) down ;;
  *) show_mode ;;
esac

