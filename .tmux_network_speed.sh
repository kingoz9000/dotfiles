#!/bin/bash

INTERFACE="wlan0"  # Change if using Ethernet (e.g., eth0)

while true; do
    OLD_TX=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    OLD_RX=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)
    sleep 1  # Refresh every second
    NEW_TX=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes)
    NEW_RX=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes)

    # Convert bytes to KB/s with 1 decimal place using awk
    TX_RATE=$(awk "BEGIN {print ($NEW_TX - $OLD_TX) / 1024}")
    RX_RATE=$(awk "BEGIN {print ($NEW_RX - $OLD_RX) / 1024}")

    echo "⮝ ${TX_RATE} KB/s ⮟ ${RX_RATE} KB/s" > /tmp/tmux_network_speed
done

