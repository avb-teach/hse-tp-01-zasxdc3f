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
  mkdir "$OUTPUT_DIR"
  cp -R "$INPUT_DIR"/* "$OUTPUT_DIR"
  while true; do
    DIRS=$(find "$OUTPUT_DIR" -mindepth $((MAX_DEPTH+1)) -maxdepth $((MAX_DEPTH+1)) -type d)
    if [ "${DIRS}" == '' ]; then break; fi
    for DIR in $DIRS; do
      DIR=${DIR#"$OUTPUT_DIR/"}
      DIRNAME=$(dirname "$OUTPUT_DIR/$DIR")
      BASENAME=$(basename "$DIRNAME")
      mkdir "$OUTPUT_DIR/$BASENAME/"
      mv "$OUTPUT_DIR/$DIR" "$OUTPUT_DIR/$BASENAME/"
    done
  done
  exit
else
  PATHS=$(find "$INPUT_DIR" -type f)
  for FILE in $PATHS
  do
    if [ -f "$OUTPUT_DIR/$(basename "$FILE")" ]; then
      cp "$FILE" "$OUTPUT_DIR/$(basename "$FILE")_"
    else
      cp -R "$FILE" "$OUTPUT_DIR/"
    fi
  done
fi
