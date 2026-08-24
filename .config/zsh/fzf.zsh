export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --margin=1,2
  --padding=1
  --prompt='  '
  --pointer='▶'
  --marker='✓'
  --separator='─'
  --scrollbar='▌▐'
  --info=inline-right
  --header-first
  --color=bg+:#1e1e2e,bg:#11111b,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#89b4fa,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#a6e3a1,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8
  --color=border:#6c7086,label:#cdd6f4,query:#cdd6f4
  --preview-window=right:55%:wrap:border-left
"

_fzf_all_files() {
  local result header cmd_all cmd_files cmd_dirs

  header="^F: All | ^G: Files | ^D: Dirs"

  if command -v fd >/dev/null 2>&1; then
    cmd_all="fd --max-depth=1 --type f --type d --hidden --strip-cwd-prefix"
    cmd_files="fd --max-depth=1 --type f --hidden --strip-cwd-prefix"
    cmd_dirs="fd --max-depth=1 --type d --hidden --strip-cwd-prefix"
  else
    cmd_all="find . -maxdepth 1 -mindepth 1 \\( -type f -o -type d \\) | sed 's|^\\./||'"
    cmd_files="find . -maxdepth 1 -mindepth 1 -type f | sed 's|^\\./||'"
    cmd_dirs="find . -maxdepth 1 -mindepth 1 -type d | sed 's|^\\./||'"
  fi

  result=$(eval "$cmd_all" | fzf \
    --header="$header" \
    --bind="ctrl-g:change-prompt(Files> )+reload($cmd_files)" \
    --bind="ctrl-d:change-prompt(Dirs>  )+reload($cmd_dirs)" \
    --bind="ctrl-f:change-prompt(All>   )+reload($cmd_all)" \
    --preview $'env FZF_TARGET=\'{}\' sh -c \'if [ -d "$FZF_TARGET" ]; then printf "\033[1;36m%s\033[0m\n\n" "$(basename "$FZF_TARGET")"; if command -v eza >/dev/null 2>&1; then eza -la --icons=always --color=always --group-directories-first --no-permissions --no-user --no-time --git "$FZF_TARGET" 2>/dev/null; else ls -la --color=always "$FZF_TARGET" 2>/dev/null; fi; elif [ -f "$FZF_TARGET" ]; then if command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:500 "$FZF_TARGET" 2>/dev/null; elif command -v batcat >/dev/null 2>&1; then batcat --color=always --style=numbers --line-range=:500 "$FZF_TARGET" 2>/dev/null; else cat "$FZF_TARGET" 2>/dev/null; fi; else echo "binary or unknown"; fi\'')

  if [ -n "$result" ]; then
    LBUFFER+="${(q)result}"
  fi

  zle reset-prompt
}

zle -N _fzf_all_files
bindkey '^F' _fzf_all_files
