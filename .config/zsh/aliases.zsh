alias ls='eza -a --icons --git --group-directories-first'
alias tree='eza --level=2 --tree --icons --group-directories-first -a'

compdef eza=ls

alias cat='bat'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'
