#!/usr/bin/sh
ROOT_DIR=$(
	cd "$(dirname "$0")"
	pwd -P
)
cd "$ROOT_DIR"

cp /etc/modprobe.d/alsa.conf	-t	./root/etc/modprobe.d 			-rv
cp /etc/NetworkManager/conf.d	-t	./root/etc/NetworkManager		-rv
cp ~/.config/nvim/init.vim	-t	./root/home/subhaditya/.config/nvim	-rv
cp ~/.config/nvim/tips.md	-t	./root/home/subhaditya/.config/nvim	-rv
cp ~/.config/nvim/autoload	-t	./root/home/subhaditya/.config/nvim	-rv
cp ~/.config/sx			-t	./root/home/subhaditya/.config		-rv
cp ~/.config/kitty		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/bspwm		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/sxhkd		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/fontconfig		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/qt5ct		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/polybar		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/ranger		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/picom		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/mpv		-t	./root/home/subhaditya/.config		-rv
cp ~/.local/bin				./root/home/subhaditya/.local/		-rv
cp ~/.zsh			-t	./root/home/subhaditya/			-rv
cp ~/.zshrc			-t	./root/home/subhaditya/
cp ~/.fzf.zsh			-t	./root/home/subhaditya/
cp ~/.p10k.zsh			-t	./root/home/subhaditya/
cp ~/.gitconfig			-t	./root/home/subhaditya/
cp ~/.asoundrc			-t	./root/home/subhaditya/
cp ~/.alsaequal.bin		-t	./root/home/subhaditya/

pacman -Qe | cut -d' ' -f1 > ./all_installed_programs

# vim: noet ts=8 sts=8
