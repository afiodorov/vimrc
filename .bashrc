set -o vi
stty -ixon

pathadd() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH:+"$PATH:"}$1"
	fi
}

export PATH=~/.npm-global/bin:$PATH

shopt -s histappend
export HISTCONTROL=erasedups:ignoreboth
export HISTIGNORE="ls:exit:pwd:clear"

export PROMPT_DIRTRIM=2
export EDITOR=vim
export PATH="${HOME}/bin:${PATH}"

alias py37="source ~/p/py37/bin/activate"
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"
alias ap="export PYTHONPATH=/home/tom/nstack/models/base-python"
alias pytest="PYTHONPATH=/home/tom/nstack/models/base-python python -m pytest"

if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
	source /usr/share/fzf/shell/key-bindings.bash
fi

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
