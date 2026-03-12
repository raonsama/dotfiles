apt update
apt full-upgrade -y

mkdir -p $HOME/.config

cp -r .bash_aliases $HOME
cp -r .bashrc $HOME
cp -r .gitconfig $HOME
cp -r .termux $HOME
cp -r .tmux $HOME
cp -r nvim $HOME/.config/

termux-reload-settings
termux-setup-storage

apt install neovim lazygit clang build-essential ripgrep fd wget curl fzf bash-completion composer nodejs golang php php-gd php-imagick php-ldap tree-sitter
