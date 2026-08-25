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
setopt INTERACTIVE_COMMENTS

FUNCNEST=100

# Bindings
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey '^Z' undo
bindkey '^Y' redo

bindkey ' ' magic-space

# Initialize zoxide
eval "$(zoxide init zsh)"

# completion
zmodload zsh/complist
autoload -Uz compinit

compinit -i -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-dirs-first true

# Fuzzy finder
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

# starship
eval "$(starship init zsh)"

# Files
source "$ZDOTDIR/fzf.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/plugins.zsh"
