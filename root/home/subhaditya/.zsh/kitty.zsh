## See https://sw.kovidgoyal.net/kitty/faq.html#i-get-errors-about-the-terminal-being-unknown-or-opening-the-terminal-failing-when-sshing-into-a-different-computer
#if [[ $TERM =~ 'kitty' ]]; then
#	function my_ssh () {
#		if kitty +kitten ssh $* || ssh $*
#		then unalias ssh
#		fi
#	}
#alias ssh-kitty=my_ssh
#alias ssh_kitty=my_ssh
#alias kitty-ssh=my_ssh
#alias kitty_ssh=my_ssh
#fi
if [[ $TERM =~ 'kitty' ]]; then alias icat="kitty +kitten icat"; fi
