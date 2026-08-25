#!/bin/bash

echo "Clearing Yay cache..."
yay -Sc --aur

echo "Cleaning Pacman cache (keeping 1 previous version)..."
paccache -rk1

echo "Removing uninstalled packages from Pacman cache..."
paccache -ruk0

echo "Done."
