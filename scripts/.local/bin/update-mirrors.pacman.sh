#!/bin/bash

# Max number of mirrors to output
MIRROR_COUNT=25

# Backup current mirror list
echo "[*] Backing up current mirrorlist..."
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

# Update mirror list using rate-mirrors
echo "[*] Updating mirrorlist using rate-mirrors..."
sudo rate-mirrors --allow-root \
  --protocol https \
  --max-mirrors-to-output $MIRROR_COUNT \
  arch | sudo tee /etc/pacman.d/mirrorlist >/dev/null

# Refresh pacman package database smoothly
echo "[*] Refreshing pacman package database..."
sudo pacman -Syu

echo "[✓] Mirrorlist updated successfully!"
