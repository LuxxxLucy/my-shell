#!/usr/bin/bash
#
# Setup tmux

ln -s ./cfg/tmux/.tmux.conf ~ 
mkdir ~/.tmux/plugins/

if [[ ! -e $dir ]]; then
    mkdir -p $dir
fi

# tmux package manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
