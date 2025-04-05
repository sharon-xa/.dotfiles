#!/bin/bash

feh --bg-scale "$(find ~/Pictures/wallpapers/ -maxdepth 1 -type f | shuf -n1)"

