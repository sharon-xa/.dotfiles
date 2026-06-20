#!/bin/bash

export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
export XDG_RUNTIME_DIR=/run/user/1000
export WAYLAND_DISPLAY=wayland-0
systemctl --user restart plasma-plasmashell
systemctl --user restart plasma-kwin_wayland
