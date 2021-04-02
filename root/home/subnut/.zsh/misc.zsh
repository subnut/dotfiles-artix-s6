alias ":q"=exit
alias ":Q"=exit
alias "cd.."="cd .."


alias py=python
export PYTHONSTARTUP=~/.pythonrc



my_diff () { colordiff -u $* | less }
alias diff=my_diff

#alias ls='ls --color'
alias l='ls -lA'
#alias l1='ls -1'
alias la='ls -la'

#alias cal3="cal -3"
#alias qr="qrencode -t UTF8"

## alias theme_light="gsettings set org.gnome.desktop.interface gtk-theme Layan-light && gsettings set org.gnome.desktop.interface icon-theme Tela-blue"
## alias theme_dark="gsettings set org.gnome.desktop.interface gtk-theme Layan-dark && gsettings set org.gnome.desktop.interface icon-theme Tela-blue-dark"


export EDITOR=nvim
export DIFFPROG="nvim -d"
alias n=nvim
if [[ $TERM =~ 'rxvt-unicode' ]]; then
	export EDITOR=vim
	export DIFFPROG=vimdiff
	alias n=vim
	export BAT_THEME=ansi
fi
alias nvimvenv="source ~/.config/nvim/venv/bin/activate"
alias nvimdiff="nvim -d"
alias nlsp="nvim --cmd 'let g:enable_lsp = 1'"

alias vimrc="vim ~/.vimrc"
alias init.vim="nvim ~/.config/nvim/init.vim"
alias bspwmrc="$EDITOR ~/.config/bspwm/bspwmrc"
alias sxhkdrc="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias zshrc="$EDITOR ~/.zshrc"

alias ra=ranger
alias wifi="nmcli dev wifi list"
alias shrug="echo -n '¯\_(ツ)_/¯' | clipcopy"
# alias copy=clipcopy
# alias picom_restart="killall picom; sleep 0.5 && sh -c 'picom &'"
# alias lock="i3lock -c 00000040 -k --pass-media-keys --pass-screen-keys	--radius 180 --ring-width 20 --linecolor 00000000 --ringcolor=ffffff --keyhlcolor=000000 --insidecolor=ffffff --indicator --ringwrongcolor ff2134  --separatorcolor 00000000 --ringvercolor 008cf7 --insidevercolor 008cf7 --insidewrongcolor ff2134 --pass-power-keys --refresh-rate=0.5 --bshlcolor=ff2134 --datestr='%A, %d %b %Y' --redraw-thread &> /dev/null"


bspwm_delete_monitor() { #{{{
	local monitor
	local desktop
	for monitor in "$@"
	do
		for desktop in $(bspc query -D -m "$monitor")
		do
			bspc desktop "$desktop".occupied --to-monitor focused
		done
		bspc monitor "$monitor" --remove
	done
}
_bspwm_delete_monitor() { compadd $(bspc query -M -m .!focused --names) }
compdef _bspwm_delete_monitor bspwm_delete_monitor #}}}


media_control() {# {{{
	local input
	while true
	do
		clear
		echo $input
		printf "> "
		read -k 1 input
		case "$input" in
			(q) clear; return;;
			(p|\ ) playerctl -a play-pause;;
			(P) playerctl previous ;;
			(n) playerctl next;;
			(s) playerctl stop;;
			(0) playerctl position 0;;
			(,) playerctl position 5-;;
			(\.) playerctl position 5+;;
			(+|=) amixer set Master 5%+ &>/dev/null;;
			(-) amixer set Master 5%- &>/dev/null;;
			esac
		done
} # }}}


