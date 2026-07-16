#!/usr/bin/env bash
#
# Phase 3: first-time bootstrap (nvim plugins, mac defaults) and print
# next-step hints. Sourced by ../setup.sh; expects $BARE in env.

if [[ $BARE -eq 0 ]] && command -v nvim >/dev/null 2>&1; then
    echo "INSTALLING nvim plugins (headless; needs network) ..."
    if ! nvim --headless +PlugInstall +qall; then
        echo "  nvim PlugInstall returned non-zero; open nvim and run :PlugInstall manually."
    fi
fi

# Mac: allow press-and-hold to repeat keys (vim-friendly). Takes effect after re-login.
if [[ "$(uname)" == "Darwin" ]]; then
    defaults write -g ApplePressAndHoldEnabled -bool false
fi

echo
echo "Done!"
echo
echo "Next steps:"
if [[ $BARE -eq 0 ]]; then
    command -v gh >/dev/null 2>&1 && echo "  - Authenticate with GitHub:  gh auth login"
    echo "  - Inside tmux, install plugins: prefix + I  (Ctrl-a then Shift-i)"
fi
if [[ "$(uname)" == "Linux" ]]; then
    command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(command -v zsh)" ] && \
        echo "  - Make zsh your login shell:  chsh -s \$(command -v zsh)"
fi
echo "  - Press-and-hold key repeat takes effect after the next login."
