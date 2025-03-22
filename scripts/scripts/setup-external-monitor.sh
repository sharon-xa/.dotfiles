#!/usr/bin/env bash

# turn off the internal monitor (eDP-1)
xrandr --output eDP-1 --off --output HDMI-1 --auto

# set external monitor resolution and the refresh rate
xrandr --output HDMI-1 --mode 1920x1080 --rate 144

