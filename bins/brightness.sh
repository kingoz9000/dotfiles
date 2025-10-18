#!/usr/bin/env bash
set -euo pipefail

get_percent() {
  local current max
  current=$(brightnessctl g)
  max=$(brightnessctl m)
  echo $(( 100 * current / max ))
}

show_osd() {
  local p="$1"
  local msg

  if [ "$p" -ge 100 ]; then
    msg="󰃠 "   # full brightness icon
  elif [ "$p" -le 0 ]; then
    msg=" "   # zero brightness / dim icon
  else
    msg="$p"
  fi

  notify-send --app-name=hardware-control -t 1000 \
    -h string:x-canonical-private-synchronous:hardware-control \
    "$msg"
}

down() {
  local percent step
  percent="$(get_percent)"

  # Pick step size based on current percent
  if [ "$percent" -lt 10 ]; then
    step="1%-"
  elif [ "$percent" -lt 30 ]; then
    step="2%-"
  elif [ "$percent" -lt 70 ]; then
    step="5%-"
  else
    step="10%-"
  fi

  brightnessctl set "$step" >/dev/null
  percent="$(get_percent)"

  # Clamp at 0
  if [ "$percent" -lt 0 ]; then
    percent=0
    brightnessctl set 0%
  fi

  show_osd "$percent"
}

up() {
  brightnessctl set "5%+" >/dev/null
  local percent
  percent="$(get_percent)"

  # Clamp at 100
  if [ "$percent" -gt 100 ]; then
    percent=100
    brightnessctl set 100%
  fi

  show_osd "$percent"
}

show_mode() {
  echo "$(get_percent)"
}

case "${1-}" in
  up) up ;;
  down) down ;;
  *) show_mode ;;
esac

