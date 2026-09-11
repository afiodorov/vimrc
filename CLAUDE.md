# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal dotfiles for a Mac, plus the glue that makes a remote Linux box (`linuxbox`,
defined in `~/.ssh/config`) feel local. There is no build, no test suite and no linter —
deploying is `make_links.sh` for the Mac and `box/deploy.sh` for the box, and verifying a
change means using the thing.

## Deployment: everything is a symlink

`./make_links.sh` symlinks repo files into `$HOME`. Two consequences that matter more
than anything else here:

- **The files in this repo *are* the live config.** `~/.zshrc` is a symlink to `.zshrc`
  here, `~/.local/bin/fidod` to `fidod`, and so on. Editing a file in the repo changes
  the running system immediately; there is no install step for an edit.
- **Any new top-level file is auto-linked.** The loop walks every top-level entry and
  defaults the target to `~/<basename>`. Only `map_files` (custom destination) and
  `ignore_files` (skip) change that. So adding a file to the repo root has a side effect
  on `$HOME` — add a `map_files` entry when the destination isn't `~/<basename>`, as
  `grabd` and `fidod` do.

`make_links.sh` does `rm -f` on the target before linking, so re-running it clobbers
whatever is at the destination.

## Two machines, one repo

Several features are a pair of programs — one on the Mac, one on the box — talking over
reverse tunnels. Both halves live here, but they are deployed differently: the Mac halves
are **symlinked** by `make_links.sh`, while `box/` is **copied** to `linuxbox` by
`box/deploy.sh`. That asymmetry is the thing to remember — a change to `box/` does
nothing until you deploy it.

    ./box/deploy.sh            # push box/ to linuxbox and restart fido-uhid.service

Because they are copies, the box can drift from the repo. Edit here and deploy; don't
edit on the box. `box/` and `win/` are in `ignore_files` so they are not symlinked into
the Mac's `$HOME`.

`devports` (a function in `.zshrc`) is the single `autossh` process that carries all of
it, and it starts the Mac-side daemons itself:

| Port | Direction | Mac side (symlinked) | Box side (`box/` → `linuxbox:~/bin/`) |
|------|-----------|----------------------|---------------------------------------|
| 2489 | reverse   | `mac-clipboard-daemon.py` | `pbcopy`, `pbpaste` |
| 2490 | reverse   | `grabd` | `grab` (a `.zshrc` function on the box) |
| 2491 | reverse   | `fidod` | `fido-uhid` |
| 5901 | forward   | `vnc` function | TigerVNC on `:1` |
| 1080 | SOCKS     | `browse` function | — |

Nothing binds to a public interface on either end; the tunnel is the only path in.

### The YubiKey bridge (`fidod` / `fido-uhid`)

The least obvious thing in the repo. It forwards a physical YubiKey plugged into the Mac
to Chrome running in the box's VNC desktop, so WebAuthn logins work there.

macOS cannot export a USB device (no `usbip` server), so this does **not** forward USB.
It forwards CTAPHID — the protocol a browser speaks to a security key — which is just
fixed 64-byte HID reports in each direction:

```
Chrome (box) -> /dev/hidrawN -> uhid -> fido-uhid -> :2491 -> tunnel -> fidod -> YubiKey (Mac)
```

`box/fido-uhid` uses the Linux kernel's `/dev/uhid` to fabricate a HID device carrying
the standard FIDO report descriptor (usage page 0xF1D0), which is exactly what Chrome
scans hidraw devices for. It needs root, so it runs as `box/fido-uhid.service` on the
box; it holds the virtual device only while the Mac is connected, and takes it away when
the key is unplugged. It is started with `--retry`, so it survives tunnel blips and an
unplugged key on its own rather than relying on systemd to restart it.

`fidod` is the one file here that is not stdlib-only: it needs `fido2` for IOKit HID
access, so its shebang points at a private venv rather than `/usr/bin/env python3`.
Recreate it with:

```sh
python3 -m venv ~/.local/share/fidod-venv
~/.local/share/fidod-venv/bin/pip install fido2
```

Useful commands:

```sh
~/.local/bin/fidod --list                      # is the key visible to the Mac at all?
ssh linuxbox 'systemctl status fido-uhid'      # is the box side up?
ssh linuxbox 'sudo journalctl -u fido-uhid -f' # why isn't the key showing in Chrome?
ssh linuxbox 'sudo fido-uhid'                  # run it in the foreground instead
```

When debugging, test against webauthn.io before a real login — a failing site flow is
much harder to read than a failing test page.

## Neovim

`init.lua` holds options and keymaps; `lazy.lua` bootstraps lazy.nvim and declares the
plugin list inline; `plugins/` holds per-plugin config modules and `ftplugin/` holds
per-filetype settings. These land under `~/.config/nvim/` via `map_files`, not at
`~/<name>` — check `make_links.sh` before adding a file, or it will be linked to the
wrong place.

## Conventions

The daemons here (`grabd`, `fidod`) share a house style worth matching: a module
docstring that explains the whole mechanism and its trust model, stdlib only where
possible, `argparse` with a `--list`/diagnostic flag, bind to `127.0.0.1` only, and a
deliberately dumb wire protocol so the other side can be a few lines of shell.

`win/` holds Windows/WSL clipboard variants; like `box/`, it is not part of the Mac
symlink set.
