#!/data/data/com.termux/files/usr/bin/env bash

# 1. Update system di awal (sekali saja cukup)
echo "Updating system..."
apt update && apt full-upgrade -y

# 2. Persiapan direktori
WORKDIR=$HOME/workspaces
mkdir -p $WORKDIR

# 3. Membuat Symlinks (dengan pengecekan agar tidak error/double)
echo "Setting up symlinks..."
files=("bash_aliases" "bashrc" "profile" "gitconfig")

for file in "${files[@]}"; do
    # Hapus file/link lama jika ada agar ln tidak gagal
    [ -e "$WORKDIR/.$file" ] && rm -rf "$WORKDIR/.$file"
    cp -r "$(pwd)/$file" "$WORKDIR/.$file"
done

# 4. Install Packages (dikelompokkan agar rapi)
echo "Installing packages..."
apt install -y \
  fish file ldd which git lazygit build-essential \
  ripgrep wget curl bash-completion

echo "Done! Selesai."

