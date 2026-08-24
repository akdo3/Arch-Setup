export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border=rounded
  --margin=1,2
  --padding=1
  --prompt='  '
  --pointer='▶'
  --marker='◆'
  --separator='─'
  --scrollbar='┃'
  --info=inline-right
  --header-first
  --ansi
  --cycle
  --color=bg+:#1e1e2e,bg:#11111b,spinner:#6c7086,hl:#f38ba8
  --color=fg:#a6adc8,header:#89b4fa,info:#6c7086,pointer:#cdd6f4
  --color=marker:#89b4fa,fg+:#cdd6f4,prompt:#89b4fa,hl+:#f38ba8
  --color=border:#313244,label:#a6adc8,query:#cdd6f4
  --color=preview-bg:#181825,preview-border:#313244
  --preview-window=right:65%:wrap:border-left
  --bind=ctrl-p:toggle-preview
"

_fzf_all_files() {
  local result list_all list_files list_dirs hidden_file

  hidden_file="/tmp/fzf_hidden_$$"
  echo 0 > "$hidden_file"

  if command -v fd >/dev/null 2>&1 && command -v eza >/dev/null 2>&1; then
    list_all="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 --type d \$hid --strip-cwd-prefix | while IFS= read -r line; do d=\$(eza -d -1 --icons=always --color=always --no-permissions --no-user --no-time \"\$line\" 2>/dev/null); [ -n \"\$d\" ] && printf \"%s\\t%s\\n\" \"\$d\" \"\$line\"; done; fd --max-depth=1 --type f \$hid --strip-cwd-prefix | while IFS= read -r line; do f=\$(eza -1 --icons=always --color=always --no-permissions --no-user --no-time \"\$line\" 2>/dev/null); [ -n \"\$f\" ] && printf \"%s\\t%s\\n\" \"\$f\" \"\$line\"; done'"
    list_files="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 --type f \$hid --strip-cwd-prefix | while IFS= read -r line; do f=\$(eza -1 --icons=always --color=always --no-permissions --no-user --no-time \"\$line\" 2>/dev/null); [ -n \"\$f\" ] && printf \"%s\\t%s\\n\" \"\$f\" \"\$line\"; done'"
    list_dirs="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 --type d \$hid --strip-cwd-prefix | while IFS= read -r line; do d=\$(eza -d -1 --icons=always --color=always --no-permissions --no-user --no-time \"\$line\" 2>/dev/null); [ -n \"\$d\" ] && printf \"%s\\t%s\\n\" \"\$d\" \"\$line\"; done'"
  elif command -v fd >/dev/null 2>&1; then
    list_all="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 \$hid --strip-cwd-prefix'"
    list_files="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 --type f \$hid --strip-cwd-prefix'"
    list_dirs="sh -c 'h=\$(cat $hidden_file 2>/dev/null || echo 0); hid=\"\"; [ \"\$h\" = \"1\" ] && hid=\"--hidden\"; fd --max-depth=1 --type d \$hid --strip-cwd-prefix'"
  else
    list_all="find . -maxdepth 1 -mindepth 1 | sed 's|^\./||' | sort"
    list_files="find . -maxdepth 1 -mindepth 1 -type f | sed 's|^\./||' | sort"
    list_dirs="find . -maxdepth 1 -mindepth 1 -type d | sed 's|^\./||' | sort"
  fi

  result=$(eval "$list_all" | fzf \
    --border-label=' Alt+H Help ' \
    --border-label-pos=-3 \
    --delimiter='\t' \
    --with-nth=1 \
    --ansi \
    --bind="change:execute-silent(sh -c 'q=\"{q}\"; if echo \"\$q\" | grep -q \"^\\\\.\"; then echo 1 > $hidden_file; else echo 0 > $hidden_file; fi')+reload($list_all)" \
    --bind="ctrl-g:change-prompt(Files  )+reload($list_files)" \
    --bind="ctrl-d:change-prompt(Dirs   )+reload($list_dirs)" \
    --bind="ctrl-f:change-prompt(All    )+reload($list_all)" \
    --bind="ctrl-h:execute-silent(h=\$(cat $hidden_file 2>/dev/null || echo 0); if [ \"\$h\" = \"1\" ]; then echo 0 > $hidden_file; else echo 1 > $hidden_file; fi)+reload($list_all)" \
    --bind $'alt-h:preview:printf "\033[38;2;137;180;250m\033[1m  Key Bindings\033[0m\n\n  ^F    All items\n  ^G    Files only\n  ^D    Directories only\n  ^H    Toggle hidden files\n  ^P    Toggle preview\n  Enter Select item\n  Esc   Cancel\n"' \
    --preview $'env FZF_TARGET=\'{2}\' sh -c \'if [ -d "$FZF_TARGET" ]; then printf "\033[1;36m%s\033[0m\n\n" "$(basename "$FZF_TARGET")"; if command -v eza >/dev/null 2>&1; then eza -1 --icons=always --color=always --group-directories-first "$FZF_TARGET" 2>/dev/null; else ls -1 --color=always "$FZF_TARGET" 2>/dev/null; fi; elif [ -f "$FZF_TARGET" ]; then if command -v bat >/dev/null 2>&1; then bat --color=always --style=numbers --line-range=:500 "$FZF_TARGET" 2>/dev/null; elif command -v batcat >/dev/null 2>&1; then batcat --color=always --style=numbers --line-range=:500 "$FZF_TARGET" 2>/dev/null; else cat "$FZF_TARGET" 2>/dev/null; fi; else echo "binary or unknown"; fi\'' \
    --preview-label=" Preview " | cut -f2)

  rm -f "$hidden_file" 2>/dev/null

  if [ -n "$result" ]; then
    LBUFFER+="${(q)result}"
  fi

  zle reset-prompt
}

zle -N _fzf_all_files
bindkey '^F' _fzf_all_files
