# How to play all songs of slushii
```
echo "\"$(find -iname '*slushii*')\"" | tr '\n' ' ' | sed 's/ \.\//" "/g' | xargs mpv
```

# How to use `pv` to indicate `dd` progress
```
pv install68.img | sudo dd of=/dev/sdb oflag=direct bs=4M conv=fsync iflag=fullblock
```

# Sleep / Suspend
[This.](https://www.kernel.org/doc/Documentation/power/states.txt)  
And [this](https://wiki.archlinux.org/index.php/Power_management#Power_management_with_systemd) too. (elogind provides this functionality)

# Automount
<strike>Install [`udiskie`](https://github.com/coldfix/udiskie) from the repo</strike>  
Install `udisks2` from the repo. Use `udiskctl` cli.

# Chroot (`artix-chroot`)
Install `artools-base` from repo

# Font-regarding
### How to check which fonts have a certain glyph?  
(Mostly needed when kitty shows character, but urxvt doesn't)
- Install `gucharmap`
In `gucharmap`, in _Find_, paste the glyph you need.  
When you successfully find the needed glyph -
- Right-click-and-hold on the desired glyph. The font used to render it will be shown in the popup (see at the last line of the popup)

