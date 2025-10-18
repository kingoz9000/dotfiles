#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="$HOME/dotfiles/bins"
TARGET_DIR="$HOME/.local/bin"

# Resolve the absolute path of this script to skip it later
SCRIPT_PATH="$(realpath "$0")"

mkdir -p "$TARGET_DIR"

for file in "$BIN_DIR"/*; do
    # Skip directories
    [ -d "$file" ] && continue

    # Skip this script itself
    [ "$file" = "$SCRIPT_PATH" ] && continue

    # Skip non-executable files (optional, but good hygiene)
    [ -x "$file" ] || continue

    # Get the base name without path or extension
    base="$(basename "${file%.*}")"

    # Create symlink
    ln -sf "$file" "$TARGET_DIR/$base"
done

# Refresh zsh / bash command cache so new symlinks are recognized
if command -v rehash &>/dev/null; then
    rehash
else
    hash -r
fi

echo "Symlinks created in $TARGET_DIR"

