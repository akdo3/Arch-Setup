# Arch-Setup

## 1.1 System Update & Install yay

```bash
sudo pacman -Syu
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sri
cd .. && rm -rf yay
```

## Network Security (Firewall)
```bash
sudo pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw
```

## 1.2 Package Installation

### Important Packages
```bash
yay -S --needed zen-browser-bin neovim zip unzip fuzzel yazi clipse sddm mpv zed
```

### Optional Packages
```
yay -S --needed waybar visual-studio-code-bin google-chrome localsend kdeconnect filelight spacedrive
```

### Showcase CLI
```
yay -S --needed fastfetch cmatrix unicmatrix cava asciiquarium sl
```

## 1.3 Zen Setup
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

## 1.4 Dark/Light Mode

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

# knowledge

| Topic                                 | Description                |
|---------------------------------------|----------------------------|
| [Wine](./knowledge/Wine.md)           | Open Windows Apps          |
| [Languages](./knowledge/Languages.md) | Programing Languages       |
| [Distrobox](./knowledge/Distrobox.md) | Install And Use Another OS |
| [Vim](./knowledge/Vim.md)             | How To Use Vim             |


