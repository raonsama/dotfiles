export PATH="$HOME/thirt-party/bin:$HOME/.go/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$PATH"
export GOPATH="$HOME/.go"
export XDG_RUNTIME_DIR="$PREFIX/tmp"

export OLLAMA_NUM_PARALLEL=1
export OLLAMA_MAX_LOADED_MODELS=1
export OLLAMA_HOST=127.0.0.1:11434
export OLLAMA_NOPRUNE=1
export OLLAMA_NO_CLOUD=true

export DO_NOT_TRACK=1

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend
shopt -s histverify
shopt -s extglob

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-color | *-256color) color_prompt=yes ;;
esac

# The following block is surrounded by two delimiters.
# These delimiters must not be modified. Thanks.
# START KALI CONFIG VARIABLES
NEWLINE_BEFORE_PROMPT=yes
# STOP KALI CONFIG VARIABLES
CHECKDISTRO=$(uname -r)

if [[ "$color_prompt" = yes ]]; then
  if [[ -f /etc/os-release ]] || [[ "$CHECKDISTRO" == *"PRoot-Distro"* ]]; then
    prompt_color='\[\033[;34m\]'
    info_color='\[\033[1;31m\]'
  else
    prompt_color='\[\033[;32m\]'
    info_color='\[\033[1;34m\]'
  fi

  prompt_symbol=󱑼

  PS1=$prompt_color'┌──${debian_chroot:+($debian_chroot)──}${VIRTUAL_ENV:+(\[\033[0;1m\]$(basename $VIRTUAL_ENV)'$prompt_color')}('$info_color'raon '$prompt_symbol' sama'$prompt_color')-[\[\033[0;1m\]\w'$prompt_color']\n'$prompt_color'└─'$info_color'\$\[\033[0m\] '

  unset prompt_color
  unset info_color
  unset prompt_symbol
else
  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt* | Eterm | aterm | kterm | gnome* | alacritty)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

[ "$NEWLINE_BEFORE_PROMPT" = yes ] && PROMPT_COMMAND="PROMPT_COMMAND=echo"

# enable color support of ls, less and man, and also add handy aliases
if [ -x $PREFIX/usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  export LS_COLORS="$LS_COLORS:ow=30;44:" # fix ls color for folders with 777 permissions

  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
  alias diff='diff --color=auto'
  alias ip='ip --color=auto'

  export LESS_TERMCAP_mb=$'\E[1;31m'  # begin blink
  export LESS_TERMCAP_md=$'\E[1;36m'  # begin bold
  export LESS_TERMCAP_me=$'\E[0m'     # reset bold/blink
  export LESS_TERMCAP_so=$'\E[01;33m' # begin reverse video
  export LESS_TERMCAP_se=$'\E[0m'     # reset reverse video
  export LESS_TERMCAP_us=$'\E[1;32m'  # begin underline
  export LESS_TERMCAP_ue=$'\E[0m'     # reset underline
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -lhF'
alias la='ls -lAh'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Handles nonexistent commands.
# If user has entered command which invokes non-available
# utility, command-not-found will give a package suggestions.
if [ -x "$PREFIX/libexec/termux/command-not-found" ]; then
  command_not_found_handle() {
    "$PREFIX"/libexec/termux/command-not-found "$1"
  }
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f $PREFIX/usr/share/bash-completion/bash_completion ]; then
    . $PREFIX/usr/share/bash-completion/bash_completion
  elif [ -f $PREFIX/etc/bash_completion ]; then
    . $PREFIX/etc/bash_completion
  fi
fi

# Autostart tmux
if [[ "$CHECKDISTRO" != *"PRoot-Distro"* ]] && [[ -z "$TMUX" ]] && [[ -n "$PS1" ]]; then
  SESSION="MateX"

  tmux attach-session -t "$SESSION" || tmux new-session -s "$SESSION"

  if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Session "$SESSION" closed. Running script..."
    exit
  fi
fi
