if [ "$TMUX" = "" ]; then tmux; fi

source ~/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle agkozak/zsh-z
antigen bundle jeffreytse/zsh-vi-mode

ZVM_VI_INSERT_ESCAPE_BINDKEY=jk

eval "$(fnm env --use-on-cd)"

export PATH="/Users/dnguyen/.local/bin:$PATH"

antigen theme lambda
alias lv="lvim"
cd ~/ws
antigen apply

