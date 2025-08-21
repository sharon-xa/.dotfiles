#!/usr/bin/env bash
set -e

# Cache DDC display detection
DDC_DISPLAY=""
if command -v ddcutil >/dev/null 2>&1; then
  DDC_DISPLAY=$(ddcutil detect 2>/dev/null | awk '/Display [0-9]+/{disp=$2}/Invalid display/{disp=""}/Display/{if(disp){print disp; exit}}')
fi

usage() {
  cat <<EOF
Usage: $0 [--internal | --external] <value>
Arguments:
  --internal   Adjust brightness of the internal (laptop) screen
  --external   Adjust brightness of the first detected external monitor
Value:
  Relative adjustment:
    +N    -> increase brightness by N units
    -N    -> decrease brightness by N units
    +N%   -> increase brightness by N percent
    N%-   -> decrease brightness by N percent
  Absolute adjustment:
    N     -> set brightness to N% of max
    N%    -> set brightness to N% of max
Examples:
  $0 --internal +10     # Increase internal brightness by 10 units
  $0 --internal 50      # Set internal brightness to 50%
  $0 --internal 10%-    # Decrease internal brightness by 10%
  $0 --external +20     # Increase external brightness by 20 units
  $0 --external 50      # Set external brightness to 50% of max
EOF
  exit 0
}

# Check for help
[[ "$1" == "--help" ]] && usage
[[ $# -ne 2 ]] && usage

TARGET="$1"
VALUE="${2// /}" # Remove spaces using parameter expansion

case "$TARGET" in
--internal)
  case "$VALUE" in
  +* | *-)
    # Relative adjustments - let brightnessctl handle them directly
    brightnessctl set "$VALUE" >/dev/null
    ;;
  *[0-9]*)
    # Absolute value - append % if not present
    [[ "$VALUE" != *% ]] && VALUE="${VALUE}%"
    brightnessctl set "$VALUE" >/dev/null
    ;;
  *)
    echo "Invalid brightness value: $VALUE" >&2
    exit 1
    ;;
  esac
  ;;

--external)
  if [[ -z "$DDC_DISPLAY" ]]; then
    echo "No DDC/CI-capable external monitor detected!" >&2
    exit 1
  fi

  # Single ddcutil call to get both current and max values
  VCP_INFO=$(ddcutil --display "$DDC_DISPLAY" getvcp 10 2>/dev/null)
  if [[ -z "$VCP_INFO" ]]; then
    echo "Failed to read brightness from external monitor" >&2
    exit 1
  fi

  # Parse current and max values in one go
  CURRENT=$(echo "$VCP_INFO" | awk -F'current value = ' '/current value/ {split($2,a,","); gsub(/ /,"",a[1]); print a[1]}')
  MAX=$(echo "$VCP_INFO" | awk -F',' '{for(i=1;i<=NF;i++) if($i ~ /max value/) {match($i, /[0-9]+/); print substr($i, RSTART, RLENGTH)}}')

  if [[ -z "$CURRENT" || -z "$MAX" ]]; then
    echo "Failed to parse brightness values from external monitor" >&2
    exit 1
  fi

  # Calculate new brightness value
  case "$VALUE" in
  +[0-9]*)
    # Increase by percentage of max
    PCT=${VALUE#+}
    PCT=${PCT%\%}
    NEW=$((CURRENT + MAX * PCT / 100))
    ;;
  -[0-9]* | *[0-9]-)
    # Decrease by percentage of max
    PCT=${VALUE#-}
    PCT=${PCT%-}
    PCT=${PCT%\%}
    NEW=$((CURRENT - MAX * PCT / 100))
    ;;
  [0-9]*)
    # Absolute percentage
    PCT=${VALUE%\%}
    NEW=$((PCT * MAX / 100))
    ;;
  *)
    echo "Invalid brightness value: $VALUE" >&2
    exit 1
    ;;
  esac

  # Clamp values
  ((NEW < 0)) && NEW=0
  ((NEW > MAX)) && NEW=$MAX

  echo "Setting external monitor brightness to $NEW/$MAX (${NEW}00/$((MAX * 100))%)"
  ddcutil --display "$DDC_DISPLAY" setvcp 10 "$NEW" 2>/dev/null
  ;;

*)
  usage
  ;;
esac
