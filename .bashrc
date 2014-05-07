export TERM=xterm-256color
export EDITOR=vim

PROMPT_COMMAND='last="$(cat /tmp/last)";lasterr="$(cat /tmp/lasterr)"; exec >/dev/tty; exec > >(tee /tmp/last); exec 2>/dev/tty; exec 2> >(tee /tmp/lasterr)'
