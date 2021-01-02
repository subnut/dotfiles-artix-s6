# vim: fdm=marker nowrap sw=0 ts=4

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=30000
setopt autocd
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/subhaditya/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


## Config
setopt EXTENDED_HISTORY			# add timestamp to .zsh_history
setopt histverify				# VERY IMPORTANT. `sudo !!` <enter> doesn't execute directly. instead, it just expands.
setopt histreduceblanks			# RemoveTrailingWhiteSpace
setopt incappendhistory			# immediately _append_ to HISTFILE instead of _replacing_ it _after_ the shell exits
setopt histignorespace			# command prefixed by space are incognito
setopt histignoredups			# ignore duplicate
bindkey "^[" vi-cmd-mode		# vi-mode
export PATH=/usr/games:$PATH	# Add Games to PATH
export PATH=/home/subhaditya/.local/bin:$PATH
export PATH=./:$PATH


### Added by Zinit's installer ###################
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
		print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
	zinit-zsh/z-a-rust \
	zinit-zsh/z-a-as-monitor \
	zinit-zsh/z-a-patch-dl \
	zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk ###############


### Prompt ######################
autoload -Uz vcs_info
vcs_info
add-zsh-hook precmd vcs_info
setopt promptsubst

typeset -g MY_PROMPT_FIRST_PROMPT=1
typeset -g PROMPT_NEW_LINE_IS_INSERTED=0
_left_prompt_elements=()

PROMPT=''
PROMPT_LEFT_SEP=$'\ue0b6'		# 
PROMPT_RIGHT_SEP=$'\ue0b4'		# 
PROMPT_PROMPT_SYMBOL=$'\ue0b0'	# 

#### Left prompt ########

# Curdir
#  PROMPT=$PROMPT'%F{99}${PROMPT_LEFT_SEP}%f%K{99} %F{232}%~%f %k'
typeset -A prompt_curdir
prompt_curdir[fg]=232
prompt_curdir[bg]=99
prompt_curdir[content]='%~'
_left_prompt_elements+=(prompt_curdir)

# Kernel upgraded
if grep -qs '^ID=arch$\|^ID=artix$' /etc/os-release && test -e /lib/modules/`uname -r`; then
	PROMPT=$PROMPT'%F{99}${PROMPT_RIGHT_SEP}%f'
else
	PROMPT=$PROMPT'%K{1}%F{99}${PROMPT_RIGHT_SEP}%f%k'
	PROMPT=$PROMPT'%K{1}%F{0}%{ REBOOT%}%f %k%F{1}${PROMPT_RIGHT_SEP}%f%b'
fi
typeset -A prompt_kernel
prompt_kernel[fg]=0
prompt_kernel[bg]=1
prompt_kernel[content]='%0($(grep -qs "^ID=arch$\|^ID=artix$" /etc/os-release && test -e /lib/modules/`uname -r` || echo 1)..%{REBOOT%})'
prompt_kernel[bold]=1
# _left_prompt_elements+=(prompt_kernel)


# Test
typeset -A test_prompt
test_prompt[fg]=1
test_prompt[bg]=16
test_prompt[content]='%{whoami%}'
_left_prompt_elements+=(test_prompt)


() {
	PROMPT=''
	local LAST_BGCOLOR=''
	local element
	for element in $_left_prompt_elements
	do
		local sep
		bgcolor=${${(P)element}[bg]}
		fgcolor=${${(P)element}[fg]}
		content=${${(P)element}[content]}
		# Simply do the bolding,underlining,etc in the 'content' field itself
		# shall take less space
		#	if [[ -n ${${(P)element}[bold]]} ]]; then
		#		content="%B$content%b"
		#	fi
		if [[ -z $LAST_BGCOLOR ]]; then
			sep=$PROMPT_LEFT_SEP
			PROMPT=$PROMPT"%F{$bgcolor}"
		else
			sep=$PROMPT_RIGHT_SEP
			PROMPT=$PROMPT"%K{$bgcolor}"
		fi
		PROMPT=$PROMPT$sep
		PROMPT=$PROMPT"%F{$bgcolor}%K{$fgcolor}"
		PROMPT=$PROMPT"%S $content %s"
		LAST_BGCOLOR=$bgcolor
		unset sep
		unset bgcolor fgcolor content
	done
	PROMPT=$PROMPT"%k$PROMPT_RIGHT_SEP%f"
	unset LAST_BGCOLOR
}


#newline
PROMPT=$PROMPT$'\n'
#prompt
PROMPT=$PROMPT'%k%F{%(?.16.1)}${PROMPT_LEFT_SEP}%f%K{%(?.16.1)} %F{%(?.10.220)}%(?.✔.✘)%f %k%F{%(?.16.1)}${PROMPT_PROMPT_SYMBOL}%f '

#### Right prompt ########################################

#exitcode if not 0
RPROMPT='%B%(?..%F{1}${PROMPT_LEFT_SEP}%f%K{1} %F{220}%?%f %k%F{1}${PROMPT_RIGHT_SEP}%f)%b'


#### Transient prompt ####################################
function _my_transient_prompt_trigger {

	# If last exit-code 0, green(2) else red(1)
	typeset -g TRANSIENT_PROMPT='%F{%(?.2.1)}❯%f '

	# Right-side prompt for transient prompt
	# typeset -g TRANSIENT_RPROMPT='%?'

	typeset -g _my_transient_prompt_saved_PROMPT=$PROMPT
	typeset -g _my_transient_prompt_saved_RPROMPT=$RPROMPT
	PROMPT=$TRANSIENT_PROMPT
	RPROMPT=$TRANSIENT_RPROMPT
	zle reset-prompt
	zle accept-line
	if [[ -v MY_PROMPT_FIRST_PROMPT ]]
	then
		add-zsh-hook precmd _my_transient_prompt_reset
		PROMPT_NEW_LINE_IS_INSERTED=0
		unset MY_PROMPT_FIRST_PROMPT
	fi
}
function _my_transient_prompt_reset {
	if [[ -n $_my_transient_prompt_saved_PROMPT && $PROMPT == $TRANSIENT_PROMPT ]]
	then
		PROMPT=$_my_transient_prompt_saved_PROMPT
		RPROMPT=$_my_transient_prompt_saved_RPROMPT
	fi
	unset _my_transient_prompt_saved_PROMPT
	unset _my_transient_prompt_saved_RPROMPT
	unset TRANSIENT_PROMPT
	unset TRANSIENT_RPROMPT
	if [[ PROMPT_NEW_LINE_IS_INSERTED -eq 0 ]]
	then
		# Add a newline before prompt
		PROMPT=$'\n'$PROMPT
		PROMPT_NEW_LINE_IS_INSERTED=1
	fi
	zle && zle reset-prompt
}
function _my_transient_prompt_remove_newline_screen_cleared {
	if [[ PROMPT_NEW_LINE_IS_INSERTED -eq 1 ]]
	then
		# Remove a newline before prompt
		PROMPT=${PROMPT/$'\n'/''}
		PROMPT_NEW_LINE_IS_INSERTED=0
	fi
	zle && zle clear-screen
}

zle -N _my_transient_prompt_trigger _my_transient_prompt_trigger
bindkey -r '^M'
bindkey '^M' _my_transient_prompt_trigger

zle -N _my_transient_prompt_remove_newline_screen_cleared _my_transient_prompt_remove_newline_screen_cleared
bindkey -r '^L'
bindkey '^L' _my_transient_prompt_remove_newline_screen_cleared

#### End of prompt ######################################






## Plugins
#use `zinit load` instead of `zinit light` to see how the plugin is being loaded
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/fast-syntax-highlighting
zinit ice as'z' pick'z.sh'
zinit light rupa/z
# zinit ice depth=1; zinit light romkatv/powerlevel10k; source ~/.p10k.zsh

## ohmyzsh plugins
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/directories.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/termsupport.zsh
# Both are same -
#     zinit snippet OMZ::plugins/git/git.plugin.zsh
#     zinit snippet 'https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'
() {
local plugin
local omz_plugins_that_are_only_a_script=(git sudo fancy-ctrl-z zsh_reload taskwarrior virtualenv pyenv fzf wd)
for plugin in $omz_plugins_that_are_only_a_script
do
	zinit snippet OMZ::plugins/$plugin/$plugin.plugin.zsh
done
}

## fzf Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# export PATH="$PYENV_ROOT/bin:$PATH"

## colorls
# export PATH="$PATH:/home/subhaditya/.gem/ruby/2.7.0/bin/"
# alias ls="colorls"

# my_run_bat () { cat $1 | powershell.exe -Command "& {cmd.exe}" - }
# my_run_bat_2 () { cat $1 | powershell.exe -Command "& {cd c:; cmd.exe /Q}" - }
# my_run_bat_3 () { powershell.exe "cd c:; & \"$( wslpath -w $1)\"" }
my_run_bat_4 () { # {{{
	if [[ $* =~ (-h) || -z $* ]]
	then echo "Execute Windows Batch files from WSL

Usage: runbat [options] path
Options:
	-h or --help	Show this help window and exit

Executes the specified file at the C: drive.
If C: is unavailable, then executes at the CMD default (Windows) directory."
	return; fi
	powershell.exe "cd c:; & \"$( wslpath -w $1)\""
} # }}}
alias runbat=my_run_bat_4



yays () { yay -S $(yay -Ss $* | cut -d' ' --fields=1 | grep .  | fzf --multi) --needed }
yayss () { yay -Ss $* }
pacs () { sudo pacman -S $(pacman -Ss $* | cut -d' ' --fields=1 | grep . | cut --fields=2 -d'/' | fzf --multi) --needed }
alias pacss="pacman -Ss"
pacr () { sudo pacman -R $(pacman -Qe $* | cut --fields=2 -d'/' | cut --fields=1 -d' '| fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }
pacrr () { sudo pacman -R $(pacman -Q $* | cut --fields=2 -d'/' | cut --fields=1 -d' '| fzf --multi --preview-window 'right:50%:nohidden:wrap' --preview 'pacman -Qi {} | grep "Name\|Version\|Description\|Required By\|Optional For\|Install Reason\|Size\|Groups" | cat') }

alias ydl=youtube-dl
my_calendar () { while true; do tput civis;clear; cal; sleep $(( 24*60*60 - `date +%H`*60*60 - `date +%M`*60 - `date +%S` )); done }
emojiinputtool () {
	while true; do
	codepoints="$(jome -f cp -p U)"
	if [ $? -ne 0 ]; then
		exit 1
	fi
	xdotool key --delay 20 $codepoints
	done
}


alias ":q"=exit
alias ":Q"=exit
alias "cd.."="cd .."

alias datausage=vnstat
vpn () { protonvpn $* && return true; echo "Running as root ..."; sudo protonvpn $*; timedatectl set-timezone Asia/Kolkata }

alias cameradisable="sudo chmod -r /dev/video*"
alias cameraenable="sudo chmod ug+r /dev/video*"
alias camerastatus="l /dev/video*"

if ! [[ -z $MY_NVIM_BG ]] && [[ $KITTY_WINDOW_ID -eq 1 ]];then
	echo 'if [[ $MY_NVIM_BG == "light" ]];then export MY_NVIM_BG="dark"; alias colorls="colorls"; export BAT_THEME="gruvbox (Dark) (Hard)"; fi' > ~/.config/kitty/custom_zsh_source
fi

# get_theme () #{{{
#		if my_variable_for_color=$(kitty @ get-colors)
#		then
#			if [[ $( echo $my_variable_for_color | grep color0 | cut -d'#' -f2) = '000000' ]]
#			then
#				export MY_NVIM_BG='light'
#				echo 'if [[ $MY_NVIM_BG == "dark" ]];then export MY_NVIM_BG="light"; fi' > ~/.config/kitty/custom_zsh_source
#			else
#				export MY_NVIM_BG='dark'
#				echo > ~/.config/kitty/custom_zsh_source
#			fi
#		fi
# #}}}
get_theme () { source ~/.config/kitty/custom_zsh_source }
if ! [[ -z $MY_NVIM_BG ]]; then source ~/.config/kitty/custom_zsh_source; fi

toggle_theme () { # {{{
	get_theme
	if [[ $MY_NVIM_BG == 'dark' ]]
	then export MY_NVIM_BG='light'
		kitty @ set-colors -a -c ~/.config/kitty/gruvbox_light_hard.conf
		alias colorls="colorls --light"
		export BAT_THEME="gruvbox (Light) (Hard)"
		echo 'if [[ $MY_NVIM_BG == "dark" ]];then export MY_NVIM_BG="light"; alias colorls="colorls --light"; export BAT_THEME="gruvbox (Light) (Hard)"; fi' > ~/.config/kitty/custom_zsh_source
	else if [[ $MY_NVIM_BG == 'light' ]]
	then export MY_NVIM_BG='dark'
		kitty @ set-colors -a -c ~/.config/kitty/gruvbox_dark_hard.conf
		alias colorls="colorls"
		export BAT_THEME="gruvbox (Dark) (Hard)"
		echo 'if [[ $MY_NVIM_BG == "light" ]];then export MY_NVIM_BG="dark"; alias colorls="colorls"; export BAT_THEME="gruvbox (Dark) (Hard)"; fi' > ~/.config/kitty/custom_zsh_source
	fi
	fi
	echo -n "get_theme\n" | kitty @ send-text -t="title:subhaditya@$(cat /proc/sys/kernel/hostname)" --stdin
} # }}}
alias to=toggle_theme


alias telebit=~/telebit
telebit_share_cur_dir () { # {{{
	trap 'echo; echo Stopping telebit; telebit disable' INT

	echo "https://wicked-emu-8.telebit.io/" | clipcopy
	if [[ -z $* ]]
	then
		telebit http ./.
	else
		telebit http $*
	fi
	telebit enable
	while sleep 1; do echo -n ''; done
} # }}}
alias telebit_share=telebit_share_cur_dir

alias py=python
export PYTHONSTARTUP=~/.pythonrc

my_diff () { colordiff -u $* | less }
alias diff=my_diff

export GPG_TTY=$(tty)
alias g=git
alias ga='git add'
alias gaa='git add --all'
alias gaav='git add --all --verbose'
alias gdh="git diff HEAD"
alias gdh1="git diff HEAD~1 HEAD"
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gp='git push'
alias gpull="git pull"
my_gcm () { git commit -m "$*" }
alias gcm=my_gcm

alias ls='ls --color'
alias l='ls -lA'
alias l1='ls -1'
alias la='ls -la'

alias cal3="cal -3"
alias qr="qrencode -t UTF8"

# alias theme_light="gsettings set org.gnome.desktop.interface gtk-theme Layan-light && gsettings set org.gnome.desktop.interface icon-theme Tela-blue"
# alias theme_dark="gsettings set org.gnome.desktop.interface gtk-theme Layan-dark && gsettings set org.gnome.desktop.interface icon-theme Tela-blue-dark"

# See https://sw.kovidgoyal.net/kitty/faq.html#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
if [[ $TERM =~ 'kitty' ]]; then
	function my_ssh () {
		if kitty +kitten ssh $* || ssh $*
		then unalias ssh
		fi
	}
alias ssh-kitty=my_ssh
alias ssh_kitty=my_ssh
alias kitty-ssh=my_ssh
alias kitty_ssh=my_ssh
fi
if [[ $TERM =~ 'kitty' ]]; then alias icat="kitty +kitten icat"; fi

alias sql_start="systemctl start mariadb"
alias sql_stop="systemctl stop mariadb"

export EDITOR=nvim
export DIFFPROG="nvim -d"
alias n=nvim
alias nvimvenv="source ~/.config/nvim/venv/bin/activate"
alias nvimdiff="nvim -d"
alias init.vim="nvim ~/.config/nvim/init.vim"
alias bspwmrc="nvim ~/.config/bspwm/bspwmrc"
alias sxhkdrc="nvim ~/.config/sxhkd/sxhkdrc"
alias zshrc="nvim ~/.zshrc"

alias wifi="nmcli dev wifi list"
alias shrug="echo -n '¯\_(ツ)_/¯' | clipcopy"
# alias copy=clipcopy
alias picom_restart="killall picom; sleep 0.5 && sh -c 'picom &'"
alias lock="i3lock -c 00000040 -k --pass-media-keys --pass-screen-keys	--radius 180 --ring-width 20 --linecolor 00000000 --ringcolor=ffffff --keyhlcolor=000000 --insidecolor=ffffff --indicator --ringwrongcolor ff2134  --separatorcolor 00000000 --ringvercolor 008cf7 --insidevercolor 008cf7 --insidewrongcolor ff2134 --pass-power-keys --refresh-rate=0.5 --bshlcolor=ff2134 --datestr='%A, %d %b %Y' --redraw-thread &> /dev/null"

alias winvm_1cpu="bspc desktop --layout monocle; VBoxManage modifyvm Win10 --cpus 1 && exec VBoxManage startvm Win10"
alias winvm_2cpu="bspc desktop --layout monocle; VBoxManage modifyvm Win10 --cpus 2 && exec VBoxManage startvm Win10"
alias winvm_4cpu="bspc desktop --layout monocle; VBoxManage modifyvm Win10 --cpus 4 && exec VBoxManage startvm Win10"

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

usb() { # {{{
	udevadm settle

	local lsblk
	local PATH_SAVED
	lsblk=$(where lsblk)
	PATH_SAVED=$PATH

	local PATH
	PATH=$PATH_SAVED
	for _ in $(lsblk -P -o PATH,RM,TYPE | grep 'RM="1"' | grep 'TYPE="disk"' | cut -d' ' -f1)
	do
		eval $(lsblk -P -o PATH,RM,TYPE | grep 'RM="1"' | grep 'TYPE="disk"' | cut -d' ' -f1)
		$lsblk $PATH -t -o NAME,SIZE,TYPE,LABEL,MOUNTPOINT
		PATH=$PATH_SAVED
	done
}
# }}}
usb_mount() { #{{{
	udisksctl mount -b "$@"
	echo
	usb
}
_usb_mount_completion() {
	local lsblk
	local PATH_SAVED
	lsblk=$(where lsblk)
	PATH_SAVED=$PATH

	local PATH
	local to_eval
	PATH=$PATH_SAVED
	for to_eval in $(lsblk -P -o PATH,RM,TYPE | grep 'RM="1"' | grep 'TYPE="part"' | cut -d' ' -f1)
	do
		eval $to_eval
		compadd $PATH
	done
	PATH=$PATH_SAVED
}
compdef _usb_mount_completion usb_mount #}}}
usb_unmount() { #{{{
	udisksctl unmount -b "$@"
	echo
	usb
}
_usb_unmount_completion() {
	local lsblk
	local PATH_SAVED
	lsblk=$(where lsblk)
	PATH_SAVED=$PATH

	local PATH
	local to_eval
	PATH=$PATH_SAVED
	for to_eval in $(lsblk -P -o PATH,RM,TYPE,MOUNTPOINT | grep 'RM="1"' | grep 'TYPE="part"' | grep -v 'MOUNTPOINT=""' | cut -d' ' -f1)
	do
		eval $to_eval
		compadd $PATH
	done
	PATH=$PATH_SAVED
}
compdef _usb_unmount_completion usb_unmount #}}}
usb_poweroff() { #{{{
	udisksctl power-off -b "$@"
	echo
	usb
}
_usb_poweroff_completion() {
	local lsblk
	local PATH_SAVED
	lsblk=$(where lsblk)
	PATH_SAVED=$PATH

	local PATH
	local to_eval
	PATH=$PATH_SAVED
	for to_eval in $(lsblk -P -o PATH,RM,TYPE | grep 'RM="1"' | grep 'TYPE="disk"' | cut -d' ' -f1)
	do
		eval $to_eval
		compadd $PATH
	done
	PATH=$PATH_SAVED
}
compdef _usb_poweroff_completion usb_poweroff #}}}
alias usbmount=usb_mount
alias usbunmount=usb_unmount
alias usbpoweroff=usb_poweroff
compdef usbmount=usb_mount
compdef usbunmount=usb_unmount
compdef usbpoweroff=usb_poweroff

autoload -Uz bashcompinit
bashcompinit
_udisksctl_completion() { # {{{
	local suggestions=$(udisksctl complete "${COMP_LINE}" ${COMP_POINT})
	COMPREPLY=($(compgen -W "$suggestions" -- ""))
}
# }}}
complete -o nospace -F _udisksctl_completion udisksctl
