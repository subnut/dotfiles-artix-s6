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

# vim: fdm=marker
