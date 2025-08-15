#!/bin/bash

output=$(ps -eo rss,comm,args --sort=-rss | head -n 4 | tail -n 3 | awk '{printf "%.2f GB\t%s %s\n", $1/1024/1024, $2, $3}')
notify-send --app-name=long-msg "Memory Usage" "$output"

