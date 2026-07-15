#!/usr/bin/env bash
#
# Phase 1: install Homebrew + dependencies.
# Sourced by ../setup.sh; expects $BARE and $REPO_DIR in env.

if [[ "$(uname)" != "Darwin" ]]; then
    echo "Install phase only supports macOS. Use --no-install elsewhere." >&2
    exit 1
fi

# Xcode CLT. `xcode-select -p` returns success as soon as the GUI installer
# starts; pkgutil confirms the package actually finished.
if ! xcode-select -p >/dev/null 2>&1 || \
   ! pkgutil --pkg-info=com.apple.pkg.CLTools_Executables >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools (a GUI prompt will appear) ..."
    xcode-select --install || true
    echo "Re-run setup.sh after the Xcode CLT installation finishes."
    exit 0
fi

# Homebrew. NONINTERACTIVE=1 skips the installer's "press RETURN" prompt;
# `sudo -v` upfront caches credentials so the password prompt is visible
# *before* brew's own output starts scrolling past.
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew ..."
    echo "(macOS will prompt for your sudo password now to cache credentials.)"
    sudo -v
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew on PATH regardless of whether it was just installed. Covers
# Apple Silicon (/opt/homebrew), Intel (/usr/local), and custom prefixes
# (anything already discoverable via PATH).
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

if [[ $BARE -eq 1 ]]; then
    echo "INSTALLING brew formulas (bare) ..."
    brew install git git-lfs tmux neovim
else
    echo "INSTALLING brew formulas (full) ..."
    brew install \
        git git-lfs tmux neovim \
        fzf zoxide lazygit node gh eza \
        starship zsh-autosuggestions zsh-syntax-highlighting zsh-completions

    # uv (Python package manager). INSTALLER_NO_MODIFY_PATH stops uv from
    # editing ~/.zshrc; the symlinked .zshrc sources ~/.local/bin/env itself.
    if ! command -v uv >/dev/null 2>&1; then
        echo "INSTALLING uv ..."
        curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
    fi

    # Claude Code CLI.
    if ! command -v claude >/dev/null 2>&1; then
        echo "INSTALLING Claude Code ..."
        npm install -g @anthropic-ai/claude-code
    fi
fi
