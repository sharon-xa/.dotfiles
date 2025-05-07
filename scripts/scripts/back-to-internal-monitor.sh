#!/usr/bin/env bash

# turn off the external monitor (HDMI-1)
xrandr --output HDMI-1 --off

# turn on and set the internal monitor (eDP-1) to its preferred mode
xrandr --output eDP-1 --auto
