#!/usr/bin/env bash
set -e

LAPTOP=$(xrandr | grep " connected" | grep -m1 "eDP" | awk '{print $1}')
EXTERNAL=$(xrandr | grep " connected" | grep -v "eDP" | awk '{print $1}' | head -n1)

# check if external monitor is connected
EXTERNAL_CONNECTED=false
if [ -n "$EXTERNAL" ]; then
  EXTERNAL_CONNECTED=true
fi

usage() {
  echo "Usage: $0 [--internal | --external | --external-left | --external-right | --mirror]"
  exit 0
}

# Get preferred resolution
get_preferred_resolution() {
  MONITOR="$1"
  xrandr | awk -v mon="$MONITOR" '
    $1==mon {p=1; next}         # start after monitor line
    p && /^[ \t]+[0-9]/ {       # mode lines start with space + digits
        print $1                # first mode listed
        exit
    }'
}

# Get maximum refresh rate
get_max_refresh() {
  MONITOR="$1"
  RESOLUTION="$2"
  xrandr | awk -v mon="$MONITOR" -v res="$RESOLUTION" '
    $1==mon {p=1; next} 
    p && /^[ \t]+[0-9]/ && $1==res {
        max=0
        for(i=2;i<=NF;i++){
            val=$i
            gsub(/[^0-9.]/,"",val)
            if(val>max) max=val
        }
        print max
        exit
    }'
}

case "$1" in
--internal)
  xrandr --output "$EXTERNAL" --off --output "$LAPTOP" --auto
  ;;
--external)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    RES=$(get_preferred_resolution "$EXTERNAL")
    MAX_RATE=$(get_max_refresh "$EXTERNAL" "$RES")
    echo "$LAPTOP"
    echo "$EXTERNAL"
    echo "$RES"
    echo "$MAX_RATE"
    xrandr --output "$LAPTOP" --off --output "$EXTERNAL" --mode "$RES" --rate "$MAX_RATE"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--external-right)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    RES=$(get_preferred_resolution "$EXTERNAL")
    MAX_RATE=$(get_max_refresh "$EXTERNAL" "$RES")
    echo "$LAPTOP"
    echo "$EXTERNAL"
    echo "$RES"
    echo "$MAX_RATE"
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --mode "$RES" --rate "$MAX_RATE" --right-of "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--external-left)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    RES=$(get_preferred_resolution "$EXTERNAL")
    MAX_RATE=$(get_max_refresh "$EXTERNAL" "$RES")
    echo "$LAPTOP"
    echo "$EXTERNAL"
    echo "$RES"
    echo "$MAX_RATE"
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --mode "$RES" --rate "$MAX_RATE" --left-of "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--mirror)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    RES=$(get_preferred_resolution "$EXTERNAL")
    MAX_RATE=$(get_max_refresh "$EXTERNAL" "$RES")
    echo "$LAPTOP"
    echo "$EXTERNAL"
    echo "$RES"
    echo "$MAX_RATE"
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --mode "$RES" --rate "$MAX_RATE" --same-as "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
*)
  usage
  ;;
esac
