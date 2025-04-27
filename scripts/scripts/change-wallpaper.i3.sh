#!/bin/bash

feh --bg-fill "$(find ~/Pictures/wallpapers/ -maxdepth 1 -type f | shuf -n1)"

