#!/data/data/com.termux/files/usr/bin/env bash

# 1. Update system di awal (sekali saja cukup)
echo "Updating system..."
apt update && apt full-upgrade -y

# 2. Install Packages (dikelompokkan agar rapi)
echo "Installing packages..."
apt install -y \
  fish file neofetch ldd which neovim \
  lazygit build-essential ripgrep fd wget curl fzf \
  bash-completion rust rust-analyzer rust-src \
  nodejs golang gopls php php-gd php-imagick php-ldap \
  tree-sitter ranger 

echo "Done! Selesai."

