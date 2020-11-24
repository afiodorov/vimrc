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

alias utxo="source ~/p/utxo/bin/activate"
alias py37="source ~/p/py37/bin/activate"
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

export GOROOT=/snap/go/current
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

complete -o default -F __start_kubectl kgn

export SPARK_HOME=/opt/spark
pathadd "$SPARK_HOME/bin"

pathadd "/opt/hadoop/bin"

export PYSPARK_DRIVER_PYTHON=jupyter
export PYSPARK_DRIVER_PYTHON_OPTS='notebook'

export JAVA_HOME=/usr

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

[[ -f "${HOME}/.bash_private" ]] && source "${HOME}/.bash_private"

[[ -f "${HOME}/vimrc/z.sh" ]] && source "${HOME}/vimrc/z.sh"
