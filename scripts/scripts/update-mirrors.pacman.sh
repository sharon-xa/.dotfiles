#!/bin/bash

# Number of mirrors to fetch
MIRROR_COUNT=25

# Backup current mirror list
echo "[*] Backing up current mirrorlist..."
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Update mirror list using reflector
echo "[*] Updating mirrorlist using Reflector..."
sudo reflector --age 12 \
               --protocol https \
               --sort rate \
               --latest $MIRROR_COUNT \
               --save /etc/pacman.d/mirrorlist

# Force refresh of package database
echo "[*] Refreshing pacman package database..."
sudo pacman -Syy

echo "[✓] Mirrorlist updated successfully!"
