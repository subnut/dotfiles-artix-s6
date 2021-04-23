# vim: fdm=marker nowrap sw=0 ts=4
# NOTE: for any kind of unknown term, see `man 1 zshall`
if which stty > /dev/null; then
	stty -echo
fi
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
setopt AUTOPUSHD
setopt CORRECT					# [nyae]? (Also see $SPROMPT)
setopt EXTENDED_HISTORY			# add timestamp to .zsh_history
setopt HIST_IGNORE_DUPS			# ignore duplicate
setopt HIST_IGNORE_SPACE		# command prefixed by space are incognito
setopt HIST_REDUCE_BLANKS		# RemoveTrailingWhiteSpace
setopt HIST_VERIFY				# VERY IMPORTANT. `sudo !!` <enter> doesn't execute directly. instead, it just expands.
setopt INC_APPEND_HISTORY		# immediately _append_ to HISTFILE instead of _replacing_ it _after_ the shell exits
bindkey "^[" vi-cmd-mode		# vi-mode
export PATH=$HOME/.local/bin:$PATH
export PATH=./:$PATH



source ~/.zsh/prompt.zsh
source ~/.zsh/key_mappings.zsh
source ~/.zsh/git.zsh
source ~/.zsh/misc.zsh
source ~/.zsh/arch_pacman.zsh
source ~/.zsh/udisksctl_and_usb.zsh



source 	~/.zsh/OMZ_snippets/key-bindings.zsh || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/key-bindings.zsh \
    -o  ~/.zsh/OMZ_snippets/key-bindings.zsh

source 	~/.zsh/OMZ_snippets/clipboard.zsh || \
    curl -L http://github.com/ohmyzsh/ohmyzsh/raw/master/lib/key-bindings.zsh \
    -o  ~/.zsh/OMZ_snippets/clipboard.zsh

### ohmyzsh plugins
# 	OMZ::lib/termsupport.zsh \
# 	OMZ::plugins/sudo/sudo.plugin.zsh


##### End of plugins ##########################


## fzf Fuzzy Finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#


# Set terminal title
function precmd    { print -Pn "\e]0;%n@%m: %~\a"; }   # user@host: ~/cur/dir
function preexec   { printf    "\e]0;$2\a";        }   # name of running command
