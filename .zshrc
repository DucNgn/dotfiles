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
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"

# Shell
if [ "$TMUX" = "" ]; then tmux; fi
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
eval "$(fzf --zsh)"

# Tools
eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"
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
