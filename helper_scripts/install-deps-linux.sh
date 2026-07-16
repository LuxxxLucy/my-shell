#!/usr/bin/env bash
#
# Phase 1 (Linux): apt packages, plus release binaries / installers for the
# tools not in Ubuntu/Mint repos. Sourced by ../setup.sh; expects $BARE and
# $REPO_DIR in env. Targets apt-based distros (Ubuntu, Linux Mint), x86_64.

if ! command -v apt-get >/dev/null 2>&1; then
    echo "Linux install path targets apt (Ubuntu / Linux Mint). Use --no-install elsewhere." >&2
    exit 1
fi

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# Bare stops at the apt set; apt neovim is fine for the no-plugin config.
if [[ $BARE -eq 1 ]]; then
    echo "INSTALLING apt packages (bare) ..."
    sudo apt-get update
    sudo apt-get install -y git git-lfs tmux neovim zsh
    return 0
fi

echo "INSTALLING apt packages (full) ..."
sudo apt-get update
sudo apt-get install -y \
    git git-lfs tmux zsh curl fzf zoxide xclip wl-clipboard nodejs npm \
    zsh-autosuggestions zsh-syntax-highlighting

# Extract one binary from a github release tarball into ~/.local/bin.
fetch_release_bin() {  # $1 tarball-url  $2 binary-name  $3 dest
    local tmp rc; tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/rel.tar.gz" "$1" \
        && tar -xzf "$tmp/rel.tar.gz" -C "$tmp" \
        && install "$tmp/$2" "$3"
    rc=$?
    rm -rf "$tmp"
    return $rc
}

# neovim: apt ships < 0.10, too old for blink.cmp. Install the release
# tarball unless a nvim >= 0.10 is already present.
if ! { command -v nvim >/dev/null 2>&1 \
    && nvim --version | head -1 | grep -qE 'v(0\.(1[0-9]|[2-9][0-9])|[1-9][0-9]*\.)'; }; then
    echo "INSTALLING neovim ..."
    tmp="$(mktemp -d)"
    curl -fsSL -o "$tmp/nvim.tar.gz" \
        https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    mkdir -p "$HOME/.local/nvim"
    tar -xzf "$tmp/nvim.tar.gz" -C "$HOME/.local/nvim" --strip-components=1
    ln -sf "$HOME/.local/nvim/bin/nvim" "$LOCAL_BIN/nvim"
    rm -rf "$tmp"
fi

# eza, lazygit: not in apt on current LTS; release binaries.
command -v eza >/dev/null 2>&1 || \
    fetch_release_bin \
        https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz \
        eza "$LOCAL_BIN/eza"
if ! command -v lazygit >/dev/null 2>&1; then
    ver=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -Po '"tag_name": *"v\K[^"]*')
    fetch_release_bin \
        "https://github.com/jesseduffield/lazygit/releases/download/v${ver}/lazygit_${ver}_Linux_x86_64.tar.gz" \
        lazygit "$LOCAL_BIN/lazygit"
fi

# gh: distro copy is stale; use the official apt repo.
if ! command -v gh >/dev/null 2>&1; then
    echo "INSTALLING gh ..."
    sudo mkdir -p -m 755 /etc/apt/keyrings
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
    sudo apt-get update
    sudo apt-get install -y gh
fi

# starship, uv, claude: official installers into ~/.local/bin.
command -v starship >/dev/null 2>&1 || \
    curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$LOCAL_BIN"
command -v uv >/dev/null 2>&1 || \
    curl -LsSf https://astral.sh/uv/install.sh | env INSTALLER_NO_MODIFY_PATH=1 sh
command -v claude >/dev/null 2>&1 || \
    curl -fsSL https://claude.ai/install.sh | bash

# zsh-completions: not packaged on apt; clone onto fpath (see .zshrc).
[ -d "$HOME/.zsh/zsh-completions" ] || \
    git clone --depth 1 https://github.com/zsh-users/zsh-completions "$HOME/.zsh/zsh-completions"
