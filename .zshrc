export FZF_DEFAULT_COMMAND='fd'

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git fzf z fzf-zsh-plugin fzf-tab pass direnv)
[[ "$OSTYPE" == darwin* ]] && plugins+=(macos)

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
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

alias claude1="CLAUDE_CONFIG_DIR=~/.claude-account1 claude --allow-dangerously-skip-permissions --chrome"
alias claude2="CLAUDE_CONFIG_DIR=~/.claude-account2 claude --allow-dangerously-skip-permissions --chrome"
if [[ "$OSTYPE" == darwin* ]]; then
    alias claude="CLAUDE_CONFIG_DIR=~/.claude-account2 claude --allow-dangerously-skip-permissions --chrome"
else
    # Linux box: Chrome runs on the VNC display :1, so point DISPLAY at it.
    alias claude="DISPLAY=\${DISPLAY:-:1} CLAUDE_CONFIG_DIR=~/.claude-account2 claude --allow-dangerously-skip-permissions --chrome"
fi

# --- remote dev box (Mac only; host `linuxbox` lives in ~/.ssh/config) ---
if [[ "$OSTYPE" == darwin* ]]; then
    # persistent session: attaches tmux `main` if it exists, else creates it
    alias dev='mosh linuxbox -- tmux new-session -A -s main'
    # mosh cannot forward ports, so tunnels are a separate connection
    alias devports='autossh -M 0 -N -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
        -D 1080 \
        -L 3000:localhost:3000 \
        -L 16686:localhost:16686 \
        -L 6379:localhost:6379 \
        -L 5901:localhost:5901 linuxbox'
fi

# --- XQuartz (Mac only): put xauth on PATH and point DISPLAY at the X server ---
if [[ "$OSTYPE" == darwin* ]] && [[ -d /opt/X11/bin ]]; then
    path+=/opt/X11/bin
    [[ -e /tmp/.X11-unix/X0 ]] && export DISPLAY="${DISPLAY:-:0}"
fi
# --- run a GUI app from the box on this Mac's screen (X11, needs XQuartz) ---
if [[ "$OSTYPE" == darwin* ]]; then
    rx() {
        # usage: rx gitk --all           (runs in ~/code/vhv-demo by default)
        #        rx -d ~/code/vimrc gitk (pick the remote directory)
        local dir="$HOME/code/vhv-demo"
        if [[ "$1" == "-d" ]]; then dir="$2"; shift 2; fi
        pgrep -x Xquartz >/dev/null || { open -a XQuartz; sleep 3; }
        [[ -e /tmp/.X11-unix/X0 ]] && export DISPLAY="${DISPLAY:-:0}"
        ssh -X -f linuxbox-x "cd ${dir} && $*"
    }
    alias rgitk='rx gitk --all'
fi

# --- browse the box's ports with no per-port forwarding (needs `devports`) ---
if [[ "$OSTYPE" == darwin* ]]; then
    # Chrome in its own profile, routed through the SOCKS tunnel. In THIS window
    # `localhost` means the BOX, so http://localhost:<anyport> just works.
    # Normal Chrome is untouched.
    devchrome() {
        # <-loopback> removes Chrome's built-in "never proxy localhost" rule,
        # which would otherwise send localhost to THIS Mac instead of the box.
        open -na "Google Chrome" --args \
            --proxy-server="socks5://localhost:1080" \
            --proxy-bypass-list="<-loopback>" \
            --user-data-dir="$HOME/.chrome-devbox" \
            "${@:-http://localhost:3000}"
    }
    # curl anything on the box: dcurl http://localhost:8899/ [curl args...]
    # socks5h = resolve hostnames on the BOX, so `localhost` means the box.
    dcurl() { curl --proxy socks5h://localhost:1080 "$@"; }
fi

# --- ad-hoc port forwards, when SOCKS is not enough --------------------------
# Uses `ssh -O forward` to add the forward to the ALREADY-RUNNING master
# connection (ControlMaster), so there is no second ssh process and no restart
# of `devports`. Takes effect immediately.
#   fwd 5432 8080     -> localhost:5432 and :8080 now hit the box
#   unfwd 5432        -> stop forwarding that one
if [[ "$OSTYPE" == darwin* ]]; then
    fwd() {
        local p
        for p in "$@"; do
            ssh -O forward -L "${p}:localhost:${p}" linuxbox 2>/dev/null \
                || { ssh -N -f linuxbox 2>/dev/null; ssh -O forward -L "${p}:localhost:${p}" linuxbox; } \
                || { echo "fwd: could not forward ${p}" >&2; continue; }
            echo "forwarding localhost:${p} -> box:${p}"
        done
    }
    unfwd() {
        local p
        for p in "$@"; do
            ssh -O cancel -L "${p}:localhost:${p}" linuxbox 2>/dev/null \
                && echo "stopped localhost:${p}" || echo "unfwd: ${p} was not forwarded" >&2
        done
    }
fi
