#!/usr/bin/env bash

# Check for AUR updates
aur=$(yay -Qua | wc -l)
ofc=$((while pgrep -x checkupdates > /dev/null ; do sleep 1; done) ; checkupdates | wc -l)

# Calculate total available updates
upd=$(( ofc + aur ))

[ "${1}" == upgrade ] && printf "[Official] %-10s\n[AUR]      %-10s\n" "$ofc" "$aur" && exit

# Show tooltip
if [ $upd -eq 0 ] ; then
    # upd="" #Remove Icon completely
    upd="󰮯"   #If zero Display Icon only
    echo "{\"text\":\"$upd\", \"tooltip\":\" Packages are up to date\"}"
else
    echo "{\"text\":\"󰮯 $upd\", \"tooltip\":\"󱓽 Official $ofc\n󱓾 AUR $aur\"}"
fi
