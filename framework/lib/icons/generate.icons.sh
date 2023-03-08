#!/bin/bash

ICONS_DIR="./icons"
ASSETS_DIR="./assets/icons"

for ICON_FILE in "$ICONS_DIR"/*.svg; do
  ICON_NAME=$(basename "$ICON_FILE" .svg)
  for RES in 1 2 3; do
    rsvg-convert -w "$((24 * RES))" -h "$((24 * RES))" "$ICON_FILE" -o "$ASSETS_DIR/$ICON_NAME-$RES"x.png
  done
done