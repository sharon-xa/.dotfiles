#!/usr/bin/env bash
CACHE_DIR="$HOME/.local/share/Steam/steamapps/shadercache"

# Color codes
RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
RESET="\033[0m"

# Collect data first
declare -a APPIDS NAMES SIZES COLORS

for dir in "$CACHE_DIR"/*/; do
  appid=$(basename "$dir")
  name=$(curl -s "https://store.steampowered.com/api/appdetails?appids=$appid&l=en" |
    jq -r '.[].data.name // "Unknown"')
  size_human=$(du -sh "$dir" | cut -f1)
  size_kb=$(du -sk "$dir" | cut -f1)

  if [ "$size_kb" -gt 2097152 ]; then
    color=$RED
  elif [ "$size_kb" -gt 1048576 ]; then
    color=$YELLOW
  else
    color=$GREEN
  fi

  APPIDS+=("$appid")
  NAMES+=("$name")
  SIZES+=("$size_human")
  COLORS+=("$color")
done

# Compute max widths
max_appid=0
max_name=0
max_size=0

for i in "${!APPIDS[@]}"; do
  ((${#APPIDS[i]} > max_appid)) && max_appid=${#APPIDS[i]}
  # Use wc -m to count characters properly for Unicode
  name_width=$(echo -n "${NAMES[i]}" | wc -m)
  ((name_width > max_name)) && max_name=$name_width
  ((${#SIZES[i]} > max_size)) && max_size=${#SIZES[i]}
done

# Print header
printf "%-${max_appid}s  %-${max_name}s  %-${max_size}s\n" "AppID" "Name" "Size"
printf "%-${max_appid}s  %-${max_name}s  %-${max_size}s\n" \
  "$(printf '%*s' "$max_appid" "" | tr ' ' '-')" \
  "$(printf '%*s' "$max_name" "" | tr ' ' '-')" \
  "$(printf '%*s' "$max_size" "" | tr ' ' '-')"

# Print rows
for i in "${!APPIDS[@]}"; do
  printf "%-${max_appid}s  %-${max_name}s  %b%-${max_size}s%b\n" \
    "${APPIDS[i]}" "${NAMES[i]}" "${COLORS[i]}" "${SIZES[i]}" "$RESET"
done
