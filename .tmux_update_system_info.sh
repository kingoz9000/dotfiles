#!/bin/bash
while true; do
  echo "$(checkupdates | wc -l)" > /tmp/tmux_updates
  echo "$(curl -s wttr.in/Aalborg?format=1 | tr -d ' ')" > /tmp/tmux_weather
  sleep 10800  # 3 hours = 10800 seconds
done
