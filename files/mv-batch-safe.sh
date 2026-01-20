#!/bin/bash

QUIET=0

show_help() {
cat <<EOF
mv-safe-seq.sh — collision-safe sequential move

Usage:
  mv-safe-seq.sh [options] SRC... DEST_DIR

Options:
  -q        Quiet mode (no output)
  -h        Show help

Description:
  Moves one or more files into DEST_DIR.
  If a filename already exists, a sequential suffix is appended:
      file.txt → file_1.txt → file_2.txt ...

Examples:
  mv-safe-seq.sh file.txt /dest
  mv-safe-seq.sh *.log /archive
  mv-safe-seq.sh -q *.csv /data
EOF
exit 0
}

# ---- Parse options ----
while [[ "$1" == -* ]]; do
    case "$1" in
        -q) QUIET=1; shift ;;
        -h|--help) show_help ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

DEST_DIR="${@: -1}"
SRC_LIST=("${@:1:$#-1}")

# ---- Validations ----
[ -d "$DEST_DIR" ] || {
    echo "Invalid input: DEST must be an existing directory"
    exit 1
}

[ ${#SRC_LIST[@]} -gt 0 ] || {
    echo "Invalid input: At least one source file must be provided"
    exit 1
}

for SRC in "${SRC_LIST[@]}"; do
    [ -f "$SRC" ] || {
        echo "Invalid input: SRC must be a file → $SRC"
        exit 1
    }
done

# ---- Moves ----
for SRC in "${SRC_LIST[@]}"; do
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
    [ $QUIET -eq 0 ] && echo "$TARGET"
done
