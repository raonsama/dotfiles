apt update
apt full-upgrade -y

mkdir -p $HOME/.config

cp -rf .bash_aliases $HOME
cp -rf .bashrc $HOME
cp -rf .gitconfig $HOME
cp -rf .termux $HOME
cp -rf .tmux $HOME
cp -rf .tmux.conf $HOME
# cp -rf nvim $HOME/.config/

apt update
apt full-upgrade -y

apt install termux-api fish file neofetch ldd which tmux neovim lazygit build-essential ripgrep fd wget curl fzf bash-completion composer rust nodejs golang php php-gd php-imagick php-ldap tree-sitter

composer global require laravel/installer
npm install -g mcp-hub@latest
