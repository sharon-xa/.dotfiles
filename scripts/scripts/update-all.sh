#!/bin/bash

# Update pacman packages
sudo pacman -Syu --noconfirm

# Update AUR packages
yay --noconfirm

# Update Flatpak packages
flatpak update -y

