#!/bin/bash
while true; do
  echo "$(ip a | grep wlan0 | grep inet | awk '{print($2)}' | cut -d '/' -f1)" > /tmp/tmux_ip
  echo "$(iwgetid -r)" > /tmp/tmux_wifi
  if nordvpn status | grep -q 'Status: Connected'; then
    vpn_server=$(nordvpn status | grep '^Hostname:' | awk '{print $2}')
    echo "🛡️$vpn_server" > /tmp/tmux_vpn
  else
    echo "❌Not connected" > /tmp/tmux_vpn
  fi

  sleep 180
done
