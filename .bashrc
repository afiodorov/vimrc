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

alias grepc="grep --color=always"
alias c="conda activate model"
alias ipython="ipython --TerminalInteractiveShell.editing_mode=vi"

export MLR_CSV_DEFAULT_RS=lf

alias mlr_csv="mlr -icsv --rs lf"

if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
	source /usr/share/fzf/shell/key-bindings.bash
fi
