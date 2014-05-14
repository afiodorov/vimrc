shopt -s histappend
export HISTCONTROL="erasedups:ignoreboth"

export TERM=xterm-256color
export EDITOR=vim

function toggle_capture() {
	if [ "$G_OUTPUT_ALWAYS_CAPTURED" == "true" ]; then
		G_OUTPUT_ALWAYS_CAPTURED=false
		exec &>/dev/tty
		unset PROMPT_COMMAND
	else
		G_OUTPUT_ALWAYS_CAPTURED=true
		PROMPT_COMMAND='last="$(cat /tmp/last)";lasterr="$(cat /tmp/lasterr)"; exec >/dev/tty; exec > >(tee /tmp/last); exec 2>/dev/tty; exec 2> >(tee /tmp/lasterr)'
	fi
}
