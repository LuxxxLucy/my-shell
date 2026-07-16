# shell and dots

Personal dotfiles.

## Quickstart

```bash
# 1. Clone the repo wherever it can live long-term (symlinks point here).
git clone https://github.com/LuxxxLucy/my-shell.git ~/some-path/my-shell
cd ~/some-path/my-shell

# 2. One command does everything: install deps + symlink configs.
./setup.sh                  # full mode with all the deps and plugins
# ./setup.sh --bare         # minimal (no plugins): tmux, neovim
# ./setup.sh --no-install   # re-link only; skip the brew/deps phase
```

## Structure

```
.
├── setup.sh
├── helper_scripts/
│   ├── install-deps-macos.sh       # Phase 1 (macOS): brew install from deps/
│   ├── install-deps-linux.sh       # Phase 1 (Linux): apt
│   ├── link-configs.sh             # Phase 2: symlinks
│   └── bootstrap.sh                # Phase 3: nvim plugins, mac defaults, hints
├── deps/                           # brew package lists
└── cfg/
    ├── ghostty/                    # config (terminal emulator)
    ├── git/                        # .gitconfig, .githelpers
    ├── nvim/                       # init.vim (full) / init-bare.vim (no plugins)
    ├── tmux/                       # .tmux.conf (full) / .tmux.conf.bare (no TPM)
    └── zsh/                        # .zshrc (full) / .zshrc.bare (no zoxide/eza/lazygit)
```

`setup.sh` runs mainly the three scripts in `helper_scripts`:
1. `install-deps-macos.sh` / `install-deps-linux.sh` — dependencies, by platform (skipped with `--no-install`).
2. `link-configs.sh` — symlinks dotfiles into `$HOME`.
3. `bootstrap.sh` — first-run hooks (nvim plugins, mac defaults).
Note that `setup.sh` will perhaps trigger the Xcode Command Line Tools installer on MacOS.
run if missing — a GUI prompt appears; re-run `setup.sh` once it
finishes.

After full setup, run `gh auth login` once to authenticate with Github.
And also use `prefix+I` inside Tmux to get the plugins right

If you later move the path the cloned repo, re-run `./setup.sh --no-install` so
symlinks point to the new path.
