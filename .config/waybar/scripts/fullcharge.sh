#!/bin/sh
output=$(sudo tlp fullcharge 2>&1)
notify-send --app-name=long-msg "TLP fullcharge" "$output"
