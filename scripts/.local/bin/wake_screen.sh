#!/bin/bash

# 1. Force Kernel/NVIDIA handshake
echo detect | sudo tee /sys/class/drm/card1-HDMI-A-1/status
echo on | sudo tee /sys/class/drm/card1-HDMI-A-1/status

# 2. Atomic Plasma Fix
# We force 4K @ 60Hz, re-enable the scale you like, and set the ICC profile.
kscreen-doctor \
  output.HDMI-A-1.enable \
  output.HDMI-A-1.mode.1 \
  output.HDMI-A-1.scale.3
