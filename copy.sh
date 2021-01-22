#!/usr/bin/sh
ROOT_DIR=$(
	cd "$(dirname "$0")"
	pwd -P
)
cd "$ROOT_DIR"

cp /etc/profile.d/polybar.sh	-t	./root/etc/profile.d/			-rv
cp /etc/modprobe.d/alsa.conf	-t	./root/etc/modprobe.d 			-rv
cp ~/.config/sx			-t	./root/home/subhaditya/.config		-rv
cp ~/.config/kitty		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/bspwm		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/sxhkd		-t	./root/home/subhaditya/.config		-rv
cp ~/.config/falkon		-t	./root/home/subhaditya/.config		-rv
cp ~/.local/bin				./root/home/subhaditya/.local/		-rv
cp ~/.zshrc				./root/home/subhaditya/.zshrc
cp ~/.p10k.zsh				./root/home/subhaditya/.p10k.zsh
cp ~/.config/nvim/init.vim	-t	./root/home/subhaditya/.config/nvim	-rv

pacman -Qe | cut -d' ' -f1 > ./all_installed_programs

# vim: noet ts=8 sts=8
