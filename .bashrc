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
pathadd "${HOME}/.cabal/bin"

export PYTHONPATH=$PYTHONPATH:~/python-modules

export GOPATH=$(readlink -f "${HOME}/go")
export GOBIN=$(readlink -f "${HOME}/go/bin")
pathadd "${GOPATH}/bin"

alias "x=xclip -selection clipboard"
alias grepc="grep --color=always"

export PYTHONSTARTUP=$HOME/.pythonrc.py

export MLR_CSV_DEFAULT_RS=lf

export MODELS_PATH=~/ravelinml

export CORE=$HOME/go/src/github.com/unravelin/core
export CDPATH=".:${CORE}"

alias mlr_csv="mlr -icsv --rs lf"

if [ -f ~/.bash_completion.d/python-argcomplete.sh ]; then
	source ~/.bash_completion.d/python-argcomplete.sh
fi

if [ -f ~/git-completion.bash ]; then
	source ~/git-completion.bash
fi

SOCK="/tmp/ssh-agent-$USER-tmux"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f /tmp/ssh-agent-$USER-tmux
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

  if [[ "$1" == "rm" ]]; then
  	  return 0
  fi

  if [[ "$1" == "head" ]]; then
  	  return 0
  fi

  return 1
}


_fzf_complete_tables() {
  if ! _should_use_fzf; then
    _bq_completer
    return
  else
    local cur_word database
    cur_word=${COMP_WORDS[COMP_CWORD]}
    if [[ "$cur_word" =~ ^[a-Z]+\..* ]]; then
            database="${cur_word%%.*}"
    fi
    if [ -n "${database}" ]; then
      bq ls -n1000000 "${database}" | tail -n+3 | awk '{print "'${database}.'"$1}' > /tmp/tables
    else
      COMPREPLY=( $(bq ls | tail -n+3 | awk '{print $1"."}' | grep -E "^${cur_word}") )
      return 0
    fi

    local selected fzf
    [ ${FZF_TMUX:-1} -eq 1 ] && fzf="fzf-tmux -d ${FZF_TMUX_HEIGHT:-40%}" || fzf="fzf"
    tput sc
    selected=$(cat /tmp/tables | $fzf -m $FZF_COMPLETION_OPTS)
    tput rc

    if [ -n "$selected" ]; then
      COMPREPLY=( "$selected" )
      return 0
    fi
  fi
}

complete -F _fzf_complete_tables -o nospace -o default -o bashdefault bq
