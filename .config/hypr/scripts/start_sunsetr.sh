#!/usr/bin/env bash
set -euo pipefail 
STATE_DIR="$HOME/.cache/sunsetr" 
STATE_FILE="$STATE_DIR/state.flag" 
mkdir -p "$STATE_DIR"

echo "on" > "$STATE_FILE"
sunsetr reload 
