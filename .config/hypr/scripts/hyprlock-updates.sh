#!/usr/bin/env bash
# Writes pacman + AUR update counts for hyprlock labels

CACHE_DIR="$HOME/.cache/hyprlock"
mkdir -p "$CACHE_DIR"

# Use absolute paths if needed (cron sometimes has a minimal PATH)
PACMAN_UPDATES=$(checkupdates | wc -l)
AUR_UPDATES=$(yay -Qua 2>/dev/null | wc -l)

echo "󰮯 $PACMAN_UPDATES 󰰴 $AUR_UPDATES" > "$CACHE_DIR/updates.txt"

