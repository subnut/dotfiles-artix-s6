#!/usr/bin/sh
ROOT_DIR=$(
  cd "$(dirname "$0")"
  pwd -P
)
cd "$ROOT_DIR"

cp /etc/profile.d/polybar.sh -t ./root/etc/profile.d/ -rv
cp ~/.config/sx -t ./root/home/subhaditya/.config -rv
cp ~/.local/bin    ./root/home/subhaditya/.local/ -rv
pacman -Qe | cut -d' ' -f1 > ./all_installed_programs
