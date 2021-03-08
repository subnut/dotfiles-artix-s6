#!/usr/bin/zsh

() {
local minutes
(( \
	minutes = $(cat /sys/class/power_supply/BAT0/energy_now) \
	* 60 / $(cat /sys/class/power_supply/BAT0/power_now) \
))
printf '%02d%% (%02d:%02d)\n' \
	$(cat /sys/class/power_supply/BAT0/capacity) \
	$(( minutes / 60 )) \
	$(( minutes % 60 ))
}
