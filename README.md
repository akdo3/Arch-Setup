# Arch-Setup

---

## 1. System Update

```bash
sudo pacman -Syu
```

---

## 2. AUR Helper (yay)

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

---

## 3. Package Installation

Run the commands below to install essential applications categorized by utility.

### System Utilities & CLI Tools
```bash
sudo pacman -S neovim fastfetch zip unzip fuzzel yazi --needed
```

### AUR Packages (via yay)
```bash
yay -S visual-studio-code-bin spotify discord
```

---
