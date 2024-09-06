export FZF_DEFAULT_COMMAND='fd'

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git fzf z macos fzf-zsh-plugin fzf-tab pass)

source $ZSH/oh-my-zsh.sh

bindkey -v
bindkey -M vicmd v edit-command-line

alias py11='source ~/py11/bin/activate'
alias c='cd ~/code'
export PATH="$HOME/bin:$PATH"
path+="$HOME/.cargo/bin"
path+="$HOME/.local/bin"
path+="$PATH:/opt/nvim-linux64/bin"

export EDITOR=vim
unsetopt BEEP

function find_and_activate_venv() {
	current_dir=$PWD

	while [ "$current_dir" != "/" ]; do
		if [ -d "$current_dir/.venv" ]; then
			source "$current_dir/.venv/bin/activate"
			return
		fi
		current_dir=$(dirname "$current_dir")
	done

	echo "No .venv folder found."
}

alias v=find_and_activate_venv

export PYTHON_KEYRING_BACKEND=keybring.backends.fail.Keyring

export GPG_TTY=$(tty)

if [ -f "$HOME/.zshrc_work" ]; then
    source "$HOME/.zshrc_work"
fi


gitroot() {
  local current_dir="$PWD"
  while [[ "$current_dir" != "/" ]]; do
    if [[ -d "$current_dir/.git" ]]; then
      echo "$current_dir"
      return 0
    fi
    current_dir="$(dirname "$current_dir")"
  done
  echo "Not inside a git repository" >&2
  return 1
}

alias cr='cd "$(gitroot)"'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

alias python=python3
