# Put Homebrew on PATH (Apple Silicon at /opt/homebrew, Intel at /usr/local).
# Required for fresh terminals to see brew-installed tools like zoxide, eza, fzf.
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# fzf: vim-friendly navigation (Ctrl-j/k list, Ctrl-h/l preview scroll, Ctrl-u/d half-page)
export FZF_DEFAULT_OPTS='--height 40% --reverse --bind=ctrl-j:down,ctrl-k:up,ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'

# init zoxide (command `z` as a smarter `cd`)
eval "$(zoxide init zsh)"
# alias `j` for zoxide, `ji` for interactive fzf picker
alias j="z"
alias ji="zi"

# jd: browse frecent dirs in fzf (vim :browse oldfiles style)
jd() {
  local dir
  dir=$(zoxide query -l | fzf --preview 'eza -l {} 2>/dev/null || ls -la {}' --prompt='cd> ') && cd "$dir"
}
bindkey -s '^G' 'jd\n'

alias lg="lazygit" # lazygit

# eza replaces `ls`
alias ls="eza -al --sort=modified -r"
alias l="ls"
alias la="ls -a"

# neovim
alias v="nvim"
alias vim="nvim"

# set vi mode
set -o vi

# uv (Python package manager) env shim
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# Claude Code
CLAUDE_ARGS=(--dangerously-skip-permissions)
alias claude='CLAUDE_CODE_NO_FLICKER=1 claude $CLAUDE_ARGS'
