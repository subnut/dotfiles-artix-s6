#!/usr/bin/sh
ROOT_DIR=$(
	cd "$(dirname "$0")"
	pwd -P
)
cd "$ROOT_DIR"

cp /etc/modprobe.d/alsa.conf	-t	./root/etc/modprobe.d 			-rv
cp /etc/NetworkManager/conf.d	-t	./root/etc/NetworkManager		-rv
cp ~/.config/nvim/init.vim	-t	./root/home/subnut/.config/nvim	-rv
cp ~/.config/nvim/tips.md	-t	./root/home/subnut/.config/nvim	-rv
cp ~/.config/nvim/autoload	-t	./root/home/subnut/.config/nvim	-rv
cp ~/.config/nvim/ftplugin	-t	./root/home/subnut/.config/nvim	-rv
cp ~/.config/sx			-t	./root/home/subnut/.config		-rv
cp ~/.config/kitty		-t	./root/home/subnut/.config		-rv
cp ~/.config/alacritty		-t	./root/home/subnut/.config		-rv
cp ~/.config/bspwm		-t	./root/home/subnut/.config		-rv
cp ~/.config/sxhkd		-t	./root/home/subnut/.config		-rv
cp ~/.config/fontconfig		-t	./root/home/subnut/.config		-rv
cp ~/.config/qt5ct		-t	./root/home/subnut/.config		-rv
cp ~/.config/polybar		-t	./root/home/subnut/.config		-rv
cp ~/.config/ranger		-t	./root/home/subnut/.config		-rv
cp ~/.config/picom		-t	./root/home/subnut/.config		-rv
cp ~/.config/mpv		-t	./root/home/subnut/.config		-rv
cp ~/.config/zathura		-t	./root/home/subnut/.config		-rv
cp ~/.config/xsettingsd		-t	./root/home/subnut/.config		-rv
cp ~/.local/bin				./root/home/subnut/.local/		-rv
cp ~/.zsh			-t	./root/home/subnut/			-rv
ln -s .zsh/.zshrc ./root/home/subnut/.zshrc
cp ~/.zprofile			-t	./root/home/subnut/
cp ~/.fzf.zsh			-t	./root/home/subnut/
cp ~/.p10k.zsh			-t	./root/home/subnut/
cp ~/.gitconfig			-t	./root/home/subnut/
cp ~/.asoundrc			-t	./root/home/subnut/
cp ~/.alsaequal.bin		-t	./root/home/subnut/
cp ~/.alsaequal.bin.saved	-t	./root/home/subnut/
cp ~/.Xdefaults			-t	./root/home/subnut/
cp ~/.vimrc			-t	./root/home/subnut/

echo '# packages from repo'	>	./all_installed_programs
echo '# ------------------'	>>	./all_installed_programs
pacman -Qenq			>>	./all_installed_programs
echo				>>	./all_installed_programs
echo				>>	./all_installed_programs
echo '# packages from AUR'	>>	./all_installed_programs
echo '# ------------------'	>>	./all_installed_programs

for package in $(pacman -Qemq); do
	echo						>>	./all_installed_programs
	echo -n "#"					>>	./all_installed_programs
	pacman -Qi $package | grep URL | cut -d : -f 2-	>>	./all_installed_programs
	echo "$package"					>>	./all_installed_programs
done

# vim: noet ts=8 sts=8
