#!/bin/bash

INTERFACE="wlan0"
DIRECTION="$1"
STATE_FILE="/tmp/net_${INTERFACE}_${DIRECTION}_prev"

if [ "$DIRECTION" = "rx" ]; then
  NOW=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
elif [ "$DIRECTION" = "tx" ]; then
  NOW=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
else
  echo "Usage: $0 [rx|tx]" >&2
  exit 1
fi

# Load previous value
if [ -f "$STATE_FILE" ]; then
  PREV=$(cat "$STATE_FILE")
else
  PREV=$NOW
fi

# Save current value for next run
echo "$NOW" > "$STATE_FILE"

# Calculate delta and convert to MB/s
DIFF=$((NOW - PREV))
MB=$(awk "BEGIN { printf \"%.2f\", $DIFF / 1024}")

printf '{"text":"%s"}\n' "$MB"
