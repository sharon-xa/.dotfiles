#!/bin/bash

# Update pacman
sudo pacman -Syu --noconfirm

# Update Flatpak packages
flatpak update -y

