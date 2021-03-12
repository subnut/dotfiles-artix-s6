# vim: fdm=marker nowrap sw=0 ts=4

# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=30000
SAVEHIST=30000
bindkey -e
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _approximate _ignored
zstyle ':completion:*' matcher-list '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' '+m:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

## Config
setopt EXTENDED_HISTORY			# add timestamp to .zsh_history
setopt HIST_IGNORE_DUPS			# ignore duplicate
setopt HIST_IGNORE_SPACE		# command prefixed by space are incognito
setopt HIST_REDUCE_BLANKS		# RemoveTrailingWhiteSpace
setopt HIST_VERIFY				# VERY IMPORTANT. `sudo !!` <enter> doesn't execute directly. instead, it just expands.
setopt INC_APPEND_HISTORY		# immediately _append_ to HISTFILE instead of _replacing_ it _after_ the shell exits
bindkey "^[" vi-cmd-mode		# vi-mode
export PATH=$HOME/.local/bin:$PATH
export PATH=./:$PATH



### Added by Zinit's installer ###################
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
	print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
	command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
	command git clone --depth 1 https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
		print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
		print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
# zinit light-mode for \
# 	zinit-zsh/z-a-rust \
# 	zinit-zsh/z-a-as-monitor \
# 	zinit-zsh/z-a-patch-dl \
# 	zinit-zsh/z-a-bin-gem-node
### End of Zinit's installer chunk ###############

zinit snippet ~/.zsh/prompt.zsh
zinit snippet ~/.zsh/key_mappings.zsh
zinit snippet ~/.zsh/git.zsh
zinit snippet ~/.zsh/misc.zsh
zinit snippet ~/.zsh/arch_pacman.zsh
zinit snippet ~/.zsh/kitty.zsh
zinit snippet ~/.zsh/kitty_kittyIDE.zsh


#### Plugins ##############################
# use `zinit load` instead of `zinit light` to see how the plugin is being loaded
# zinit light mfaerevaag/wd
# zinit ice as'z' pick'z.sh'; zinit light rupa/z
# zinit ice depth=1; zinit light romkatv/powerlevel10k; source ~/.p10k.zsh


zinit ice wait lucid atload'_zsh_autosuggest_start'; zinit light zsh-users/zsh-autosuggestions
zinit wait lucid for \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
		light-mode zdharma/fast-syntax-highlighting \
	atload"!_zsh_autosuggest_start" \
		light-mode zsh-users/zsh-autosuggestions


### ohmyzsh plugins
zinit wait lucid for \
	OMZ::lib/clipboard.zsh
zinit snippet OMZ::plugins/zsh_reload/zsh_reload.plugin.zsh
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/termsupport.zsh

## Both are same -
##     zinit snippet OMZ::plugins/git/git.plugin.zsh
##     zinit snippet 'https://github.com/ohmyzsh/ohmyzsh/raw/master/plugins/git/git.plugin.zsh'

# zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh

##### End of plugins ##########################


## fzf Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

