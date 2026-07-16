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

# c-fmt: clang-format C/C++ in place. Arg is a file or dir (recursive);
# style comes from `~/.clang-format`
c-fmt() {
  local target="${1:-.}"
  local files
  if [ ! -e "$target" ]; then
    echo "c-fmt: no such path '$target'" >&2
    return 1
  fi
  if [ -d "$target" ]; then
    files=("${(@f)$(find "$target" \( -name '*.c' -o -name '*.h' -o -name '*.cpp' \
      -o -name '*.hpp' -o -name '*.cc' -o -name '*.cxx' \) -print)}")
  else
    files=("$target")
  fi
  files=("${(@)files:#}")  # drop empties (e.g. no matches)
  if [ ${#files} -eq 0 ]; then
    echo "c-fmt: no C/C++ files under '$target'"
    return 0
  fi
  local f diff_out add del total_add=0 total_del=0 changed=0
  for f in "${files[@]}"; do
    diff_out=$(clang-format "$f" | diff -- "$f" -) || true
    add=$(print -r -- "$diff_out" | grep -c '^>')
    del=$(print -r -- "$diff_out" | grep -c '^<')
    if ! clang-format -i "$f"; then
      echo "c-fmt: clang-format failed on '$f'" >&2
      return 1
    fi
    if (( add || del )); then
      changed=$((changed + 1))
      total_add=$((total_add + add))
      total_del=$((total_del + del))
      printf '  +%-4d -%-4d %s\n' $add $del "$f"
    fi
  done
  printf 'c-fmt: %d/%d file(s) changed, +%d -%d lines\n' \
    $changed ${#files} $total_add $total_del
}

# set vi mode
set -o vi

# fzf: Ctrl-R history, Ctrl-T files, Alt-C cd (after `set -o vi`)
source <(fzf --zsh)

# Claude Code
CLAUDE_ARGS=(--dangerously-skip-permissions)
alias claude='CLAUDE_CODE_NO_FLICKER=1 claude $CLAUDE_ARGS'

if [[ -n "$HOMEBREW_PREFIX" ]]; then
    FPATH="$HOMEBREW_PREFIX/share/zsh-completions:$FPATH"

    # rebuild completion cache once a day
    autoload -Uz compinit
    if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then compinit; else compinit -C; fi

    # make completion case-insensitive
    zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

    source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    # Tab accepts the grey autosuggestion when one shows, else completes.
    # Fallback is fzf-completion so the normal fzf Tab behavior is preserved.
    zstyle ':completion:*' menu select
    _tab_accept_or_complete() {
        if [[ -n "$POSTDISPLAY" ]]; then
            zle autosuggest-accept
        elif zle -l fzf-completion; then
            zle fzf-completion
        else
            zle expand-or-complete
        fi
    }
    zle -N _tab_accept_or_complete
    bindkey '^I' _tab_accept_or_complete

    eval "$(starship init zsh)"
    source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi
