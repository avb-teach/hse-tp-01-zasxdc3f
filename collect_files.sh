#!/bin/bash

OPTS=$(getopt -l "max_depth:" -- -- "$@")
eval set -- "$OPTS"
while [ $# -gt 0 ]
do
  case "$1" in
    --max_depth) MAX_DEPTH="$2"; shift 2; break;;
    *) break
  esac
done

INPUT_DIR="$1"
OUTPUT_DIR="$2"

if [ -n "$MAX_DEPTH" ]; then
  PATHS=$(find "$INPUT_DIR" -maxdepth "$MAX_DEPTH" -type f)
else
  PATHS=$(find "$INPUT_DIR" -type f)
fi
for FILE in $PATHS

do
  if [ -f "$OUTPUT_DIR/$(basename "$FILE")" ]; then
    cp "$FILE" "$OUTPUT_DIR/$(basename "$FILE")_"
  else
    cp "$FILE" "$OUTPUT_DIR/"
  fi
done
