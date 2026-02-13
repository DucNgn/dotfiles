# Homebrew (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
  export PATH="/opt/homebrew/bin:$PATH"
fi

# Antigen - plugin management
source ~/.config/antigen.zsh
antigen use oh-my-zsh

# Essential bundles
antigen bundle git
antigen bundle command-not-found
antigen bundle agkozak/zsh-z
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions

antigen apply

# Vim mode with history search
bindkey -v
bindkey ^R history-incremental-search-backward
bindkey ^S history-incremental-search-forward

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias nv="nvim"
