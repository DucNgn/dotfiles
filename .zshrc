# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY

# PATH
typeset -U path PATH
if [[ "$OSTYPE" == darwin* ]]; then
  path=(
    /usr/local/bin
    /usr/local/sbin
    /opt/homebrew/bin
    /opt/homebrew/sbin
    $path
  )
fi
path=(
  "$HOME/.local/bin"
  "$path[@]"
  "$HOME/.rvm/bin"
)
export PATH

# Shell
if [[ -z "$TMUX" ]] && command -v tmux >/dev/null 2>&1; then
  tmux
fi
PROMPT='> '
bindkey -v
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    PROMPT='[N] > '
  else
    PROMPT='> '
  fi
  zle reset-prompt
}
zle -N zle-keymap-select
bindkey '^E' autosuggest-accept
bindkey '^F' forward-word
[[ "$PWD" == "$HOME" ]] && cd ~/ws

# Plugins
source ~/.config/antigen.zsh
antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen apply

# Secrets
source ~/.config/secrets.zsh

# fzf
if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

# Tools
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias nv="nvim"
alias cl="claude"

# Functions
kctx() {
  local ctx
  ctx=$(kubectl config get-contexts -o name | fzf --height=10 --prompt="kube ctx> ") && kubectl config use-context "$ctx"
}
