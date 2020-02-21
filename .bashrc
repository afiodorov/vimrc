set -o vi
stty -ixon

pathadd() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH:+"$PATH:"}$1"
	fi
}

shopt -s histappend
export HISTCONTROL=erasedups:ignoreboth
export HISTIGNORE="ls:exit:pwd:clear"

export PROMPT_DIRTRIM=2
export EDITOR=vim
export PATH="${HOME}/bin:${PATH}"

alias py37="source ~/p/py37/bin/activate"
alias music="source ~/p/music/bin/activate"
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"
alias g="cd ${HOME}/go/src/gitlab.com/glassnode/"
alias gn="cd ${HOME}/gn"

export GOROOT=/snap/go/current
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export GOPRIVATE=gitlab.com/glassnode/*

alias kgn="kubectl -n glassnode"
alias kjn="kubectl -n jobs"
complete -o default -F __start_kubectl kgn

if [[ -f "${HOME}/.bash_private" ]]; then
	source "${HOME}/.bash_private"
fi
