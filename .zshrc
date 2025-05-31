export FZF_DEFAULT_COMMAND='fd'

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git fzf z macos fzf-zsh-plugin fzf-tab pass)

source $ZSH/oh-my-zsh.sh

bindkey -v
bindkey -M vicmd v edit-command-line

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

export PYTHON_KEYRING_BACKEND=keyring.backends.null.Keyring

export GPG_TTY=$(tty)

if [ -f "$HOME/.zshrc_work" ]; then
    source "$HOME/.zshrc_work"
fi


gitroot() {
  local dir="$PWD"

  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" || -f "$dir/.git" ]]; then
      # found either a .git directory or the .git “file” that points to
      # the actual gitdir of a worktree
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done

  echo "Not inside a git repository" >&2
  return 1
}

alias cr='cd "$(gitroot)"'

alias python=python3
unalias ls


# 1. Load NVM (must be before anything that uses nvm commands/functions)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 2. Now load your load-nvmrc logic
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "n/a" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(pwd=$oldpwd nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc
