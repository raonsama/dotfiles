nah() {
  git reset --hard
  git clean -df
  if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then
    git rebase --abort
  fi
}

clean() {
  echo "Cleaning APT package cache..."
  apt clean
  apt autoclean
  apt autoremove --purge -y
  echo "Cleaning Composer & Node package cache..."
  composer cc
  npm cache clean --force
  # echo "Vacuuming system logs..."
  # journalctl --vacuum-time=3d
  echo "Cleaning user caches..."
  rm -rf /home/*/.cache/*
  rm -rf $HOME/*/.cache/*
  echo "Cleaning app caches..."
  rm -rf /data/data/com.termux/cache/*
  echo "Cleaning temporary files..."
  rm -rf /tmp/*
  rm -rf /var/tmp/*
  rm -rf $PREFIX/tmp/*
  echo "Cleaning History..."
  rm -f $HOME/.bash_history
}

viret() {
  rm -rf $HOME/intelephense
  rm -rf $HOME/.cache/*
  rm -rf $HOME/.local/share/nvim
  rm -rf $HOME/.local/state/nvim
  chmod -R 700 $HOME/.go
  rm -rf $HOME/.go
}

alias aptup='apt update && apt full-upgrade'
alias root='pd sh termux-docker --isolated --bind $HOME/workspaces:$HOME --bind $HOME/programming:$HOME/code'
alias toor='pd sh debian --isolated --bind $HOME/workspaces:/root --bind $HOME/programming:/root/code'

alias gi='git init'
alias ga='git add'
alias gs='git status'
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gf='git fetch'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gp='git push -u origin main'

alias serve='composer run dev'
alias comp='composer'
alias art='php artisan'
alias oll='ollama serve'
