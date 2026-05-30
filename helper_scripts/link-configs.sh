#!/usr/bin/env bash
#
# Phase 2: symlink configs from this repo into $HOME.
# Sourced by ../setup.sh; expects $BARE and $REPO_DIR in env.

echo "LINKING git config ..."
ln -shf "$REPO_DIR/cfg/git/.gitconfig" ~/.gitconfig
ln -shf "$REPO_DIR/cfg/git/.githelpers" ~/.githelpers

echo "LINKING zsh ..."
if [[ $BARE -eq 1 ]]; then
    ln -shf "$REPO_DIR/cfg/zsh/.zshrc.bare" ~/.zshrc
else
    ln -shf "$REPO_DIR/cfg/zsh/.zshrc" ~/.zshrc
fi

echo "LINKING tmux ..."
if [[ $BARE -eq 1 ]]; then
    ln -shf "$REPO_DIR/cfg/tmux/.tmux.conf.bare" ~/.tmux.conf
else
    ln -shf "$REPO_DIR/cfg/tmux/.tmux.conf" ~/.tmux.conf
    mkdir -p ~/.tmux/plugins
    # Check for .git, not just the dir, so a partial/broken clone gets repaired.
    if [ ! -d ~/.tmux/plugins/tpm/.git ]; then
        rm -rf ~/.tmux/plugins/tpm
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    fi
fi

echo "LINKING nvim ..."
mkdir -p ~/.config/nvim
if [[ $BARE -eq 1 ]]; then
    ln -shf "$REPO_DIR/cfg/nvim/init-bare.vim" ~/.config/nvim/init.vim
else
    ln -shf "$REPO_DIR/cfg/nvim/init.vim" ~/.config/nvim/init.vim
fi

echo "LINKING ghostty ..."
mkdir -p ~/.config/ghostty
ln -shf "$REPO_DIR/cfg/ghostty/config" ~/.config/ghostty/config

echo "LINKING starship ..."
# Bare installs keep zsh's stock prompt and never use starship.
if [[ $BARE -eq 0 ]]; then
    ln -shf "$REPO_DIR/cfg/starship/starship.toml" ~/.config/starship.toml
fi
