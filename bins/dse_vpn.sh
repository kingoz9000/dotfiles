#!/usr/bin/env bash
set -euo pipefail
icon_dse_vpn_on=""
status=$()

show_mode(){
  if ip link show dse &>/dev/null; then
    echo "{\"text\":\"$icon_dse_vpn_on\",\"tooltip\":\"Connected to DSE\",\"class\":\"on\"}"
  else
    echo "{\"text\":\"\",\"tooltip\":\"\",\"class\":\"off\"}"
  fi
}

toggle_mode(){
  if ip link show dse &>/dev/null; then
    sudo wg-quick down dse
    notify-send "DSE VPN Disconnected"
  else
    sudo wg-quick up dse
    notify-send "DSE VPN Connected"
  fi
}

if [[ ${1-} == "toggle" ]]; then
  toggle_mode
else
  show_mode
fi

