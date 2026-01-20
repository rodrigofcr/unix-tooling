#!/bin/bash

SRC="$1"
DEST_DIR="$2"

# --- Validations ---
[ -f "$SRC" ] || {
    echo "Invalid input: SRC must be a file"
    exit 1
}

[ -d "$DEST_DIR" ] || {
    echo "Invalid input: DEST must be an existing directory"
    exit 1
}

# --- Collision-safe move ---
BASE="$(basename "$SRC")"
NAME="${BASE%.*}"
EXT="${BASE##*.}"

TARGET="$DEST_DIR/$BASE"
SEQ=1

while [ -e "$TARGET" ]; do
    TARGET="$DEST_DIR/${NAME}_$SEQ.$EXT"
    ((SEQ++))
done

mv "$SRC" "$TARGET"
echo "$TARGET"
