# shell and dots

Personal dotfiles. Run `./setup.sh <email>` for full setup, or `./setup.sh <email> --bare` on machines without plugin managers or external tools.

## Structure

```
cfg/
├── git/        .gitconfig, .githelpers
├── nvim/       init.vim (full) / init-bare.vim (no plugins)
├── tmux/       .tmux.conf (full) / .tmux.conf.bare (no TPM)
└── zsh/        .zshrc (full) / .zshrc.bare (no zoxide/exa/lazygit)
```

Bare configs keep the same keybindings and settings, swapping plugin features for built-ins (e.g. nvim-tree → netrw, spelunker → built-in spell).
