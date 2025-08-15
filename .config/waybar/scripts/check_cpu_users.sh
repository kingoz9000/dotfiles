#!/bin/bash

output=$(ps -eo pcpu,comm,args --sort=-pcpu | head -n 4 | tail -n 3 | awk '{printf "%.2f%%\t%s %s\n", $1, $2, $3}')
notify-send --app-name=long-msg "CPU Usage" "$output"

