#!/usr/bin/env bash
set -e

LAPTOP=$(xrandr | grep " connected" | grep -m1 "eDP" | awk '{print $1}')
EXTERNAL=$(xrandr | grep " connected" | grep -v "eDP" | awk '{print $1}' | head -n1)

# check if external monitor is connected
if [ -n "$EXTERNAL" ]; then
  EXTERNAL_CONNECTED=true
else
  EXTERNAL_CONNECTED=false
fi

usage() {
  echo "Usage: $0 [--internal | --external | --external-left | --external-right | --mirror]"
  exit 1
}

case "$1" in
--internal)
  xrandr --output "$EXTERNAL" --off --output "$LAPTOP" --auto
  ;;
--external)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    xrandr --output "$LAPTOP" --off --output "$EXTERNAL" --auto
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--external-right)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --auto --right-of "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--external-left)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --auto --left-of "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
--mirror)
  if [ "$EXTERNAL_CONNECTED" = true ]; then
    xrandr --output "$LAPTOP" --auto --output "$EXTERNAL" --auto --same-as "$LAPTOP"
  else
    echo "No external monitor detected!"
    exit 1
  fi
  ;;
*)
  usage
  ;;
esac
