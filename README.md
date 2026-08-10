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

## 1.4 Zen Setup
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
## 3. Container

### 3.1 Package Installation
```
yay -S distrobox podman --needed
```

### 3.2 Create Container
```
distrobox create --name testbox --image archlinux:latest
```

or:
```
distrobox-create -n testbox -i archlinux
```

### 3.3 Open The Container
```
distrobox enter testbox
```

### 3.4 Install Package
```
sudo pacman -Syu && sudo pacman -S 'appname'
```

### 3.5 Open GUI
```
distrobox-export -a 'appname'
```

### 3.6 Remove The Container
```
distrobox rm testbox
```

# knowledge

| Topic | Description | Navigate |
|----------|----------------------|----------|
| Wine     | Open Windows Apps    | [Go →](./knowledge/Wine_Installation.md) |
| Languages| Programing Languages | [Go →](./knowledge/Languages.md) |


