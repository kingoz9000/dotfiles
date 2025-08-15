#!/bin/bash

status=$(playerctl status 2>/dev/null)
if [ "$status" != "Playing" ]; then
  rm -f /tmp/cover.jpg
  > /tmp/last_cover_url
  exit 0
fi

url=$(playerctl metadata mpris:artUrl 2>/dev/null)
last_url=$(cat /tmp/last_cover_url 2>/dev/null)

if [ "$url" != "$last_url" ]; then
  curl -s "$url" -o /tmp/cover.jpg
  song=$(playerctl metadata xesam:title 2>/dev/null)
  artist=$(playerctl metadata xesam:artist 2>/dev/null)
  echo "{\"text\": \"_\", \"tooltip\": \"${song}\\n${artist}\"}"
  if [ $? -eq 0 ]; then
    echo "$url" > /tmp/last_cover_url
  else
    echo "Failed to download album art." >&2
    exit 1
  fi
fi

