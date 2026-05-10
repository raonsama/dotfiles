#!/data/data/com.termux/files/usr/bin/env bash

# 1. Persiapan direktori
WORKDIR=$HOME/workspaces
mkdir -p $WORKDIR

# 2. Copy settings  (dengan pengecekan agar tidak error/double)
echo "Copy settings..."
files=("bash_aliases" "bashrc" "profile" "gitconfig")

for file in "${files[@]}"; do
    # Hapus file lama jika ada agar tidak gagal
    [ -e "$WORKDIR/.$file" ] && rm -rf "$WORKDIR/.$file"
    cp -r "$(pwd)/$file" "$WORKDIR/.$file"
done

cp $(pwd)/first.sh $WORKDIR/

echo "Done! Selesai."

