#!/bin/bash

GOV_FILE="/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
current_governor=$(cat "$GOV_FILE")

icon_perf=""
icon_powersave="󰌪"

toggle_mode() {
  if [ "$current_governor" = "powersave" ]; then
    sudo tlp ac >/dev/null 2>&1
    echo "{\"text\":\"$icon_perf\",\"tooltip\":\"Performance\",\"class\":\"performance\"}"
  else
    sudo tlp bat >/dev/null 2>&1
    echo "{\"text\":\"$icon_powersave\",\"tooltip\":\"Powersave\",\"class\":\"powersave\"}"
  fi
}

show_mode() {
  if [ "$current_governor" = "powersave" ]; then
    echo "{\"text\":\"$icon_powersave\",\"tooltip\":\"Powersave\",\"class\":\"powersave\"}"
  else
    echo "{\"text\":\"$icon_perf\",\"tooltip\":\"Performance\",\"class\":\"performance\"}"
  fi
}

if [ "$1" = "toggle" ]; then
  toggle_mode
else
  show_mode
fi

