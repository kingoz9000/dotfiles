#!/bin/bash
while true; do
  echo "$(ip a | grep wlan0 | grep inet | awk '{print($2)}' | cut -d '/' -f1)" > /tmp/tmux_ip
  echo "$(iwgetid -r)" > /tmp/tmux_wifi
  sleep 60
done
