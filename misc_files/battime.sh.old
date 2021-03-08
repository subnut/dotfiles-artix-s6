#!/usr/bin/zsh

() {
local POWER_SUPPLY_POWER_NOW
local POWER_SUPPLY_ENERGY_NOW
local minutes
eval $(
	grep '\(ENERGY\|POWER\)_NOW'\
	/sys/class/power_supply/BAT0/uevent
)
(( minutes = POWER_SUPPLY_ENERGY_NOW \
	* 60 \
	/ POWER_SUPPLY_POWER_NOW
))
printf '%02d%% (%02d:%02d)\n' \
	$(cat /sys/class/power_supply/BAT0/capacity) \
	$(( minutes / 60 )) \
	$(( minutes % 60 ))
}
