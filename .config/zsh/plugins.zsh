ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

_zplugin_clean() {
  local dir="${1%/}"
  setopt localoptions extendedglob
  local plugin="${dir:t}"
  local -a files

  case "$plugin" in
    zsh-autosuggestions|zsh-history-substring-search)
      files=("${dir}"/^(*.plugin.zsh|${dir:t}.zsh|.git)(ND))
      (( $#files )) && rm -rf "${files[@]}"
      ;;
    fast-syntax-highlighting)
      files=(
        "${dir}"/(.github|images|share|test|tests)(ND)
        "${dir}"/(*.(md|adoc|txt)|LICENSE*|COPYING*|.gitignore|.gitattributes|.editorconfig|.zunit.yml)(ND)
      )
      (( $#files )) && rm -rf "${files[@]}"
      ;;
  esac
}

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
    _zplugin_clean "$plugin_path"
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*(/); do
    echo "Updating ${dir:t}..."
    git -C "$dir" reset --hard HEAD >/dev/null 2>&1
    git -C "$dir" pull --ff-only
    _zplugin_clean "$dir"
  done
}

_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zdharma-continuum fast-syntax-highlighting
_zplugin_load zsh-users zsh-history-substring-search
