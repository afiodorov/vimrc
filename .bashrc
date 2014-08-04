set -o vi

shopt -s histappend
export HISTCONTROL="erasedups:ignoreboth"
HISTIGNORE="ls:exit:pwd:clear"

export TERM=xterm-256color
export EDITOR=vim

export PATH=/home/tfiodoro/bin:$PATH
export PATH=/home/tfiodoro/.local/bin:$PATH
export PATH=/space/.local/bin:$PATH
export PATH=/home/tfiodoro/.gem/ruby/2.1.0/bin:$PATH

export PYTHONPATH=$PYTHONPATH:~/python-modules

alias "x=xclip -selection clipboard"
alias meld="PATH=/usr/bin/ meld"

source ~/.bash_completion.d/python-argcomplete.sh

if [ -f ~/git-completion.bash ]; then
source ~/git-completion.bash
fi

for name in `tmux ls -F '#{session_name}'`; do
  tmux setenv -g -t $name DISPLAY $DISPLAY #set display for all sessions
done

function realpath() {
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

function setdisplay() {
	export DISPLAY="localhost:""$1"".0"
}
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

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fda - including hidden directories
fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fh - repeat history
fh() {
  eval $(([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s | sed 's/ *[0-9]* *//')
}

# fkill - kill process
fkill() {
  ps -ef | sed 1d | fzf -m | awk '{print $2}' | xargs kill -${1:-9}
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch "$@") &&
  branch=$(echo "$branches" | fzf +s +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | xargs basename)
}

# fco - checkout git commit
fco() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}

# ftags - search ctags
ftags() {
  local line
  [ -e tags ] &&
  line=$(
    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
    cut -c1-80 | fzf --nth=1,2
  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
                                      -c "silent tag $(cut -f2 <<< "$line")"
}
