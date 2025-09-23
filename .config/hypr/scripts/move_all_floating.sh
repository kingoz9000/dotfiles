#!/bin/bash

# desired floating size
WIN_W=800
WIN_H=800
MARGIN=0   # gap from edges

# get monitor size (first monitor)
read -r MON_W MON_H <<< $(hyprctl monitors -j | jq -r '.[0] | "\(.width) \(.height)"')

# compute top-right position
POS_X=$((MON_W - WIN_W - MARGIN ))
POS_Y=$((MARGIN))
POS_Y=$MARGIN

# loop over floating windows
hyprctl clients -j | jq -r '.[] | select(.floating) | .address' | while read -r addr; do
    # set size
    hyprctl dispatch resizewindowpixel exact $WIN_W $WIN_H,address:$addr
    # move to top-right
    hyprctl dispatch movewindowpixel exact $POS_X $POS_Y,address:$addr
done

