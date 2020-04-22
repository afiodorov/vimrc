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
alias bayes="source ~/p/bayes/bin/activate"
alias pys="source ~/p/spark/bin/activate"
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

export SPARK_HOME=/opt/spark
pathadd "$SPARK_HOME/bin"

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

if [[ -f "${HOME}/.bash_private" ]]; then
	source "${HOME}/.bash_private"
fi
