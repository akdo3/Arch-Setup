# Distrobox

## Installation
```bash
yay -S distrobox podman --needed
```

## Create Container
```bash
distrobox create --name testbox --image archlinux:latest --home ~/Documents/distrobox-homes/testbox
```

### or:
```bash
distrobox-create -n testbox -i archlinux
```

## Open The Container
```bash
distrobox enter testbox
```

### Install Package

### Update The System & Install yay
```bash
sudo pacman -Syu && sudo pacman -S app-name
sudo pacman -S base-devel git --needed
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

### Open GUI For App
```bash
distrobox-export -a app-name
```

## Remove The Container
```bash
bash -c 'BOX="$1"; distrobox enter "$BOX" -- bash -c "for app in \$(distrobox-export --list-apps 2>/dev/null); do distrobox-export --app \"\$app\" --delete 2>/dev/null; done" 2>/dev/null; distrobox-rm --rm-home "$BOX"' bash testbox

distrobox-rm --rm-home testbox
```
