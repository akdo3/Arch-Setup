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

### Important Packages
```bash
yay -S zen-browser-bin neovim fastfetch zip unzip fuzzel yazi clipse sddm mpv zed --needed
```

### Optional Packages
```
yay -S waybar visual-studio-code-bin google-chrome localsend kdeconnect filelight spacedrive --needed
```

### Showcase CLI
```
yay -S cmatrix unicmatrix cava asciiquarium sl --needed
```

## Zen Setup
```
touch /home/akdo/.config/zen/yt41fcwo.Default (release)/chrome/userChrome.css
zeditor /home/akdo/.config/zen/yt41fcwo.Default (release)/chrome/userChrome.css
```

past this:
```
#urlbar[open]:not([usertyping]) .urlbarView {
  display: none !important;
}

#urlbar[open][usertyping] .urlbarView {
  display: block !important;
}
```

Search:
```
about:config
```

then search:
```
toolkit.legacyUserProfileCustomizations.stylesheets
```
and enable it.

## 1.5 Dark/Light Mode

### Dark Mode
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Light Mode

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
```

## 2. Fix Wifi

```bash
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

And Put This:
```
[connection]
wifi.powersave = 2
```

---

```bash
sudo nano /etc/sysctl.d/99-sysctl.conf
```

And Put This:
```
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```

Restart:
```bash
sudo systemctl restart NetworkManager
```


## 3. Langues

### 3.1 Python

```bash
yay -S python-ipykernel python-pandas python-numpy python-seaborn python-matplotlib python-scikit-learn python-pandas-stubs --needed
```

### 3.2 Rust

#### Installation
```
yay -S rustup --needed
```

####  Compile
```bash
cargo build --release
cp target/release/prayer_rust ~/.config/waybar/scripts/prayer
```

## 4. Wine Installation

```bash
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
```bash
wine app-path
```

To use the GUI:
```bash
yay winegui --needed
```
