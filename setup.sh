#!/data/data/com.termux/files/usr/bin/env bash

# 1. Update system di awal (sekali saja cukup)
echo "Updating system..."
apt update && apt full-upgrade -y

# 2. Persiapan direktori
mkdir -p $HOME/.config
mkdir -p $HOME/workspaces
mkdir -p $HOME/programming
[ -d "$HOME/.termux" ] && rm -rf "$HOME/.termux"

# 3. Membuat Symlinks (dengan pengecekan agar tidak error/double)
echo "Setting up symlinks..."
files=("bash_aliases" "bashrc" "profile" "gitconfig" "termux" "tmux" "tmux.conf")

for file in "${files[@]}"; do
    # Hapus file/link lama jika ada agar ln tidak gagal
    [ -e "$HOME/.$file" ] && rm -rf "$HOME/.$file"
    ln -s "$(pwd)/$file" "$HOME/.$file"
done

# 4. Install Packages (dikelompokkan agar rapi)
echo "Installing packages..."
apt install -y \
  termux-api fish file neofetch ldd which tmux neovim \
  lazygit build-essential ripgrep fd wget curl fzf \
  bash-completion composer rust rust-analyzer rust-src \
  nodejs golang gopls php php-gd php-imagick php-ldap \
  tree-sitter proot-distro ranger

# 5. Install Laravel Installer
if command -v composer &> /dev/null; then
    echo "Installing Laravel..."
    composer global require laravel/installer
fi

# 6. Setup Neovim Config
echo "Cloning Neovim config..."
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone -b lazy git@github.com:raonsama/nvim.git "$HOME/.config/nvim"
else
    echo "Nvim config already exists, skipping clone."
fi

echo "Done! Selesai."

