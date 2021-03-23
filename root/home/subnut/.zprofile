## For qt5ct
export QT_QPA_PLATFORMTHEME=qt5ct

## For polybar
export HWMON_PATH="/sys/class/hwmon/hwmon$(for i in /sys/class/hwmon/hwmon*/temp*_input;do echo \"$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)\";done|grep Tdie |grep -o 'hwmon[1-9]' | grep -o '[1-9]')/temp2_input"
export WIFI_INTERFACE=$(ip link | sed 's/^.: \(.*\):.*/\1/g' | grep '^wl')

## Start X
if [ $(tty) = '/dev/tty1' ]; then
	sx
fi
