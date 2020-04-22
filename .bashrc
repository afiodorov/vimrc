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

function update-x11-forwarding
{
    if [ -z "$STY" -a -z "$TMUX" ]; then
        echo $DISPLAY > ~/.display.txt
    else
        export DISPLAY=`cat ~/.display.txt`
    fi
}

# This is run before every command.
preexec() {
    # Don't cause a preexec for PROMPT_COMMAND.
    # Beware!  This fails if PROMPT_COMMAND is a string containing more than one command.
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return

    update-x11-forwarding

    # Debugging.
    #echo DISPLAY = $DISPLAY, display.txt = `cat ~/.display.txt`, STY = $STY, TMUX = $TMUX
}
trap 'preexec' DEBUG

if [[ -f "${HOME}/.bash_private" ]]; then
	source "${HOME}/.bash_private"
fi
