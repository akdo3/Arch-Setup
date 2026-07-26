# Arch-Setup

## 1. System Update

```bash
sudo pacman -Syu
```

## 2. AUR Helper (yay)

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

## 3. Package Installation

### System Utilities & CLI Tools
```bash
yay -S waybar visual-studio-code-bin zen-browser-bin google-chrome neovim fastfetch zip unzip fuzzel yazi clipse sddm mpv btop --needed
```

## 4. Wine Installation

```
sudo nvim /etc/pacman.conf
sudo pacman -Syu
sudo pacman -S wine winetricks wine-mono wine-gecko --needed
```

Uncomment in the bottom:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

To use it:
```
wine app-path
```

To use the GUI:
```
yay winegui --needed
```

---
