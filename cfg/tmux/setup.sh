#!/usr/bin/bash
#
# Setup tmux

cp ./cfg/tmux/.tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux/plugins/

# tmux package manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
