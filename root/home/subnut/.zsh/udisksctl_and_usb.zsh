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
		eval $_
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

# vim: fdm=marker
