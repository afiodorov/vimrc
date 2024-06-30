export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git fzf z macos fzf-zsh-plugin fzf-tab)

source $ZSH/oh-my-zsh.sh

bindkey -v
bindkey -M vicmd v edit-command-line

alias py11='source ~/py11/bin/activate'
alias c='cd ~/code'
export PATH="$HOME/bin:$PATH"
path+="$HOME/.cargo/bin"
