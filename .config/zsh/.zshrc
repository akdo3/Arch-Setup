# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Shell behaviour
setopt AUTOCD
setopt NUMERIC_GLOB_SORT
setopt CORRECT
setopt CORRECT_ALL
setopt INTERACTIVE_COMMENTS

# Bindings
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

# Initialize zoxide
eval "$(zoxide init zsh)"

# completion
zmodload zsh/complist
autoload -Uz compinit

compinit -C -i -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-dirs-first true
