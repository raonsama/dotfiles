nah () {
    git reset --hard
    git clean -df
    if [ -d ".git/rebase-apply" ] || [ -d ".git/rebase-merge" ]; then
        git rebase --abort
    fi
}

clean () {
    apt clean
    apt autoclean
    composer cc
    npm cache clean --force
    rm -rf $PREFIX/tmp/*
    rm -f $HOME/.bash_history
}

alias aptup='apt update && apt full-upgrade'

alias gi='git init'
alias ga='git add'
alias gs='git status'
alias gl="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
alias gf='git fetch'

alias crd='composer run dev'
alias cpr='composer'
alias art='php artisan'
