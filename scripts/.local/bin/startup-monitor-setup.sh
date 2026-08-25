#!/bin/bash

# Get external monitor (HDMI or DP)
monitor=$(xrandr | grep -E "^(HDMI|DP)[0-9-]+ connected" | awk '{print $1}' | head -n1)

if [ -n "$monitor" ]; then
  echo "External monitor detected: $monitor"

  # Get highest resolution
  best_mode=$(xrandr | grep -A1000 "^$monitor connected" | grep -Eo "^[[:space:]]+[0-9]+x[0-9]+" | awk '{$1=$1};1' | sort -u -nr | head -n1)

  if [ -n "$best_mode" ]; then
    echo "Best resolution: $best_mode"

    # Get highest refresh rate for that resolution
    best_rate=$(xrandr | grep -A1000 "^$monitor connected" | grep -A1 " $best_mode" | grep -Eo "[0-9]+\.[0-9]+" | sort -nr | head -n1)

    if [ -n "$best_rate" ]; then
      echo "Best rate: $best_rate"
      xrandr --output "$monitor" --mode "$best_mode" --rate "$best_rate" --primary
    else
      echo "Could not determine refresh rate for $monitor"
    fi
  else
    echo "Could not determine best resolution for $monitor"
  fi
else
  echo "No external monitor detected. Skipping."
fi
