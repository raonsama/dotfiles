#!/data/data/com.termux/files/usr/bin/env bash

# 1. Update system di awal (sekali saja cukup)
echo "Updating system..."
apt update && apt full-upgrade -y

# 2. Persiapan direktori
mkdir -p $HOME/.config
mkdir -p $HOME/programming
# mkdir -p $HOME/workspaces
[ -d "$HOME/.termux" ] && rm -rf "$HOME/.termux"

# 3. Membuat Symlinks (dengan pengecekan agar tidak error/double)
echo "Setting up symlinks..."
files=("bash_aliases" "bashrc" "profile" "gitconfig" "termux" "tmux" "tmux.conf")

for file in "${files[@]}"; do
    # Hapus file/link lama jika ada agar ln tidak gagal
    [ -e "$HOME/.$file" ] && rm -rf "$HOME/.$file"
    ln -s "$(pwd)/$file" "$HOME/.$file"
done

[ -e "$PREFIX/bin/startx" ] && rm -f "$PREFIX/bin/startx"
ln -s "$(pwd)/startxfce4_termux.sh" "$PREFIX/bin/startx"

# 4. Install Packages (dikelompokkan agar rapi)
echo "Installing packages..."
apt install -y x11-repo
apt update
apt install --fix-missing --fix-broken -y \
  termux-api termux-x11-nightly pulseaudio xfce4 tur-repo \
  fish file ldd which tmux neovim lazygit build-essential \
  ripgrep fd wget curl fzf bash-completion composer \
  nodejs golang rust php php-gd php-imagick php-ldap \
  tree-sitter ranger

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

