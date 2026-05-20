# shell and dots

Personal dotfiles.

## Quickstart

```bash
# 1. Clone the repo wherever it lives long-term (symlinks point here).
git clone https://github.com/LuxxxLucy/my-shell.git ~/workspace/my-shell
cd ~/workspace/my-shell

# 2. One command does everything: install deps + symlink configs.
./setup.sh
# ./setup.sh --bare         # minimal (no plugins): git, git-lfs, tmux, neovim
# ./setup.sh --no-install   # re-link only; skip the brew/deps phase
```

`setup.sh` triggers the Xcode Command Line Tools installer on first
run if missing — a GUI prompt appears; re-run `setup.sh` once it
finishes. After full setup, run `gh auth login` once to authenticate
with GitHub (stores creds in the macOS keychain).

If you later move the cloned repo, re-run `./setup.sh --no-install` so
symlinks point to the new path.

## What `setup.sh` does

Three phases delegated to `helper_scripts/`:

1. `install-deps.sh` — Homebrew + dependencies (skipped with `--no-install`).
2. `link-configs.sh` — symlinks dotfiles into `$HOME`.
3. `bootstrap.sh` — first-run hooks (nvim plugins, mac defaults).

Re-runs are safe; every step is idempotent.

## Bare mode

`./setup.sh --bare` skips all plugin work — no tpm, no nvim plugins,
no fzf shell hooks — so it needs no internet beyond the initial brew
install. Same keybindings as full mode, plugin features swapped for
built-ins (nvim-tree → netrw, spelunker → built-in spell). Useful on
servers or offline machines.

## Structure

```
.
├── setup.sh                # thin orchestrator
├── helper_scripts/
│   ├── install-deps.sh     # Phase 1: brew + deps
│   ├── link-configs.sh     # Phase 2: symlinks
│   └── bootstrap.sh        # Phase 3: nvim plugins, mac defaults, hints
└── cfg/
    ├── ghostty/            config (terminal emulator)
    ├── git/                .gitconfig, .githelpers
    ├── nvim/               init.vim (full) / init-bare.vim (no plugins)
    ├── tmux/               .tmux.conf (full) / .tmux.conf.bare (no TPM)
    └── zsh/                .zshrc (full) / .zshrc.bare (no zoxide/eza/lazygit)
```
