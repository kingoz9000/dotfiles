#!/usr/bin/env bash
# Writes today's and tomorrow's events to cache files for hyprlock labels.

set -euo pipefail

CACHE_DIR="$HOME/.cache/hyprlock"
mkdir -p "$CACHE_DIR"

# Get lists (may be empty). '|| true' so assignment succeeds even if khal exits non-zero.
today="$(khal list today 1d 2>/dev/null | tail -n +2 || true)"
tomorrow="$(khal list tomorrow 1d 2>/dev/null | tail -n +2 || true)"

# Fill in defaults if empty, but don't exit early.
: "${today:=何もない}"
: "${tomorrow:=何もない}"

# Write files, preserving newlines/spacing.
printf '%s\n' "$today" > "$CACHE_DIR/today.txt"
printf '%s\n' "$tomorrow" > "$CACHE_DIR/tomorrow.txt"

