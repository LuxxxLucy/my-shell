# init zoxide (command `z` as a smarter `cd`)
eval "$(zoxide init zsh)"
# alias `j` for zoxide
alias j="z"

alias lg="lazygit" # lazygit

# exa that replace `ls`
alias ls="exa -l"
alias l="ls"
alias la="ls -a"

# neovim
alias v="nvim"
alias vim="nvim"

# set vi mode
set -o vi
