set -o vi

shopt -s histappend
export HISTCONTROL=erasedups:ignoreboth
export HISTIGNORE="ls:exit:pwd:clear"

export EDITOR=vim

export PATH=$HOME/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cabal/bin:$PATH
export PATH=/usr/local/sbin:$PATH

export PYTHONPATH=$PYTHONPATH:~/python-modules

export GOPATH="${HOME}/go"
export PATH="${PATH}:${GOPATH}/bin"

alias "x=xclip -selection clipboard"
alias grepc="grep --color=always"
alias vimsql="vim -c \"set ft=sql\""
alias query="gcloud alpha bigquery query"

export PYTHONSTARTUP=$HOME/.pythonrc.py

if [ -f ~/.bash_completion.d/python-argcomplete.sh ]; then
	source ~/.bash_completion.d/python-argcomplete.sh
fi

if [ -f ~/git-completion.bash ]; then
	source ~/git-completion.bash
fi

SOCK="/tmp/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f /tmp/ssh-agent-$USER-screen
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

function setdisplay() {
	export DISPLAY="localhost:""$1"".0"
}

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

_should_use_fzf() {
  set -- $COMP_LINE
  shift
  while [[ $1 == -* ]]; do
    shift
  done

  if [[ "$1" == "show" ]]; then
  	  return 0
  fi

  return 1
}


_fzf_complete_tables() {
  if ! _should_use_fzf; then
    _bq_completer
    return
  else
    [ -n "${COMP_WORDS[COMP_CWORD]}" ] && return 1

    local selected fzf
    [ ${FZF_TMUX:-1} -eq 1 ] && fzf="fzf-tmux -d ${FZF_TMUX_HEIGHT:-40%}" || fzf="fzf"
    tput sc
    selected=$(cat ~/tables | $fzf -m $FZF_COMPLETION_OPTS)
    tput rc

    if [ -n "$selected" ]; then
      COMPREPLY=( "$selected" )
      return 0
    fi
  fi
}

complete -F _fzf_complete_tables -o nospace -o default -o bashdefault bq
