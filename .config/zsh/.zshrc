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
setopt NUMERIC_GLOB_SORT
setopt INTERACTIVE_COMMENTS

FUNCNEST=100

# Plugins
source "$ZDOTDIR/plugins.zsh"

# Bindings
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

bindkey '^Z' undo
bindkey '^[[122;6u' redo

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey ' ' magic-space

# completion
zmodload zsh/complist
autoload -Uz compinit
compinit -i -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' rehash true
zstyle ':completion:*' list-dirs-first true

# starship
eval "$(starship init zsh)"

# aliases
alias ls='eza -a --icons --git --group-directories-first'
alias tree='eza --level=2 --tree --icons --group-directories-first -a'

[[ -n "$GHOSTTY_RESOURCES_DIR" ]] && builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" 2>/dev/null
