#!/usr/bin/bash
#
# Usage: setup.sh <email> [--bare]
#
# --bare: use minimal configs without plugin dependencies

set -e

# Provide email
if [[ -z "$1" ]] ; then
    echo 'Email argument not provided. Aborting!'
    exit 1
fi

BARE=0
if [[ "$2" == "--bare" ]]; then
    BARE=1
    echo "Running in BARE mode (no plugins)"
fi

echo "CONFIGURING Git ..."
git config --global user.name "LU Jialin"
git config --global user.email "$1"

echo "CONFIGURING zsh ..."
if [[ $BARE -eq 1 ]]; then
    cp ./cfg/zsh/.zshrc.bare ~/.zshrc
else
    cp ./cfg/zsh/.zshrc ~/.zshrc
fi

echo "CONFIGURING tmux ..."
if [[ $BARE -eq 1 ]]; then
    cp ./cfg/tmux/.tmux.conf.bare ~/.tmux.conf
else
    . ./cfg/tmux/setup.sh
fi

echo "CONFIGURING nvim ..."
mkdir -p ~/.config/nvim
if [[ $BARE -eq 1 ]]; then
    cp ./cfg/nvim/init-bare.vim ~/.config/nvim/init.vim
else
    cp ./cfg/nvim/init.vim ~/.config/nvim/init.vim
fi

echo "Done!"

# in mac-os, enable press one key and quickly repeat it
defaults write -g ApplePressAndHoldEnabled -bool false
