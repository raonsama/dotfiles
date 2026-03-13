apt update
apt full-upgrade -y

mkdir -p $HOME/.config

cp -r .bash_aliases $HOME
cp -r .bashrc $HOME
cp -r .gitconfig $HOME
cp -r .termux $HOME
cp -r .tmux $HOME
cp -r .tmux.conf $HOME
cp -r nvim $HOME/.config/

apt update
apt full-upgrade -y

apt install fish tmux neovim lazygit clang build-essential ripgrep fd wget curl fzf bash-completion composer nodejs golang php php-gd php-imagick php-ldap tree-sitter
