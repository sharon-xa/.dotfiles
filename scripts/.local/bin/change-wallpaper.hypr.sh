#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/Pictures/wallpapers/"

WALLPAPER_FILE=$(find "${WALLPAPER_DIR}" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) | shuf -n1)

if [ -z "$WALLPAPER_FILE" ]; then
  echo "Error: No wallpaper files found in $WALLPAPER_DIR" >&2
  exit 1
fi

hyprctl hyprpaper preload "${WALLPAPER_FILE}"
hyprctl hyprpaper wallpaper "HDMI-A-1,${WALLPAPER_FILE}"
hyprctl hyprpaper unload all
