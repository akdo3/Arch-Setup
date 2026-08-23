# ZSH

## Installation
```bash
sudo pacman -S --needed zsh eza bat zoxide ttf-hack-nerd
```

## Change Default Shell
```bash
chsh -s $(which zsh)
```

## Change Config Files From Home Folder To .config Folder
```bash
sudo nvim /etc/zsh/zshenv
```

and past:
```
if [[ -z "$XDG_CONFIG_HOME" ]]
then
  export XDG_CONFIG_HOME="$JOME/.config"
fi

if [[ -d "$XDG_CONFIG_HOME/zsh" ]]
then
  export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
fi
```

