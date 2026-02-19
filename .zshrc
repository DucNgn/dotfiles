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
# Aliases
alias nv="nvim"
alias cl="claude"

# Functions
kctx() {
  local ctx
  ctx=$(kubectl config get-contexts -o name | fzf --height=10 --prompt="kube ctx> ") && kubectl config use-context "$ctx"
}
