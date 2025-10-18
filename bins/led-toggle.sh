#!/usr/bin/env bash
set -euo pipefail
for LED in "$@"; do
  if [ -f "$LED" ]; then
    v=$(cat "$LED")
    [ "$v" = 0 ] && printf 1 > "$LED" || printf 0 > "$LED"
  fi
done
