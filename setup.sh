apt update
apt full-upgrade -y

mkdir -p $HOME/.config
rm -rf $HOME/.termux

ln -s $(pwd)/bash_aliases $HOME/.bash_aliases
ln -s $(pwd)/bashrc $HOME/.bashrc
ln -s $(pwd)/gitconfig $HOME/.gitconfig
ln -s $(pwd)/termux $HOME/.termux
ln -s $(pwd)/tmux $HOME/.tmux
ln -s $(pwd)/tmux.conf $HOME/.tmux.conf

apt update
apt full-upgrade -y

apt install -y termux-api fish file neofetch ldd \
  which tmux neovim lazygit build-essential ripgrep \
  fd wget curl fzf bash-completion composer rust \
  rust-analyzer rust-src nodejs golang gopls php php-gd \
  php-imagick php-ldap tree-sitter

composer global require laravel/installer
git clone -b lazy git@github.com:raonsama/nvim.git $HOME/.config/nvim
