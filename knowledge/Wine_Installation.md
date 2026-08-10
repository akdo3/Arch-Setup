# Wine Installation

```bash
sudo nvim /etc/pacman.conf
sudo pacman -Syu
sudo pacman -S wine winetricks wine-mono wine-gecko --needed
```

### Uncomment in the bottom:
```
[multilib]
Include = /etc/pacman.d/mirrorlist
```

### To use it:
```bash
wine app-path
```

### To use the GUI:

#### Install The GUI
```bash
yay winegui --needed
```

#### Open The GUI
```
winegui
```
