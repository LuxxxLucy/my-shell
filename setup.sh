#!/usr/bin/bash
#
# Usage: setup.sh <email>

set -e

# Provide email
if [[ -z "$1" ]] ; then
    echo 'Email argument not provided. Aborting!'
    exit 1
fi

echo "CONFIGURING Git ..."
# Add my git stuff
git config --global user.name "Jialin Lu"
git config --global user.email "$1"

echo "CONFIGURING tmux ..."
. ./cfg/tmux/setup.sh

echo "Done!"
