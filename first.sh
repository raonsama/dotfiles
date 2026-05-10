#!/data/data/com.termux/files/usr/bin/env bash

# 1. Update system di awal (sekali saja cukup)
echo "Updating system..."
apt update && apt full-upgrade -y

# 2. Install Packages (dikelompokkan agar rapi)
echo "Installing packages..."
apt install -y \
  fish file ldd which git lazygit build-essential \
  ripgrep wget curl bash-completion

echo "Done! Selesai."

