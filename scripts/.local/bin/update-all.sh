#!/bin/bash

if ! sudo -n pacman -Q >/dev/null 2>&1; then
  echo "❌ ERROR: This script requires passwordless sudo rights."
  echo ""
  echo "SOLUTION: Run the following command manually:"
  echo "   sudo visudo"
  echo ""
  echo "Then add this line to the very bottom of the file:"
  echo "   $USER ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay"
  exit 1
fi

echo "✅ Permissions verified. Starting update..."

yay -Syyu --noconfirm
flatpak update -y

echo "🎉 All updates complete!"
