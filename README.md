# Arch-Setup

## System Update

```bash
sudo pacman -Syu
```

## Network Security (Firewall)
```bash
sudo pacman -S ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
sudo systemctl enable ufw
```

## Package Installation

### Important Packages
```bash
pacman -S --needed zen-browser-bin neovim zip unzip yazi mpv proton-vpn-gtk-app zed
```

### Optional Packages
```
pacman -S --needed waybar visual-studio-code-bin google-chrome fuzzel sddm clipse localsend kdeconnect filelight spacedrive
```

### Showcase CLI
```
pacman -S --needed fastfetch cmatrix unicmatrix cava asciiquarium sl
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

## zed

### Extensions
```
Material Icon Theme
Rainbow CSV
```

## Dark/Light Mode

### Dark Mode
```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

### Light Mode

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
```

## Fix Wifi

### way 1
```bash
sudo nano /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
```

And Put This:
```
[connection]
wifi.powersave = 2
```

### way 2
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

### way 3
```bash
sudo nano /etc/iwd/main.conf
```

past this:
```
[General]
EnableNetworkConfiguration=true

[Network]
NameResolvingService=systemd
```

restart:
```bash
sudo systemctl restart iwd
```

### way 4 (Disable Wi-Fi Power Save)
```bash
sudo nano /etc/udev/rules.d/81-wifi-powersave.rules
```

add this line:
```
ACTION=="add", SUBSYSTEM=="net", KERNEL=="wlan*", RUN+="/usr/bin/iw dev %k set power_save off"
```

## Fix Microphone
```bash
pavucontrol
```
1. Go to Input Devices.
2. chose Microphone (unplugged)
3. Set As Default.


## Install yay (AUR Helper)
```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -sri
cd .. && rm -rf yay
```

### yay Package
```bash
yay -S --needed cloudflare-warp-bin
```

# knowledge

| Topic                                   | Description                |
|-----------------------------------------|----------------------------|
| [ZSH](./knowledge/ZSH.md)               | Terminal Shell             |
| [Quickshell](./knowledge/Quickshell.md) | status bars                |
| [Wine](./knowledge/Wine.md)             | Open Windows Apps          |
| [Vinegar](./knowledge/Vinegar.md)       | To Download Roblox Studio  |
| [Languages](./knowledge/Languages.md)   | Programing Languages       |
| [Distrobox](./knowledge/Distrobox.md)   | Install And Use Another OS |
| [Vim](./knowledge/Vim.md)               | How To Use Vim             |


