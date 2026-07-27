# Arch-Setup

## 1.1 System Update

```bash
sudo pacman -Syu
```

## 1.2 AUR Helper (yay)

```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd .. && rm -rf yay
```

## 1.3 Package Installation

### System Utilities & CLI Tools
```bash
yay -S waybar visual-studio-code-bin zen-browser-bin google-chrome neovim fastfetch zip unzip fuzzel yazi clipse sddm mpv zed --needed
```

## 1.5 Dark/Light Mode

### Dark Mode
```
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Light Mode
```
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
```

## 2. Wine Installation

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
## 3. Python

```
yay -S python-ipykernel python-pandas python-numpy python-seaborn python-matplotlib python-scikit-learn python-pandas-stubs --needed
```

## 4. Rust Compile

```
cargo build --release
cp target/release/prayer_rust ~/.config/waybar/scripts/prayer
```

