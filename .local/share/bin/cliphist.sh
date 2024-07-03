#!/usr/bin/env sh


#// set variables

scrDir=$(dirname "$(realpath "$0")")
roconf="~/.config/rofi/config.rasi"

#// set rofi scaling

[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
wind_border=$((hypr_border * 3 / 2))
elem_border=$([ $hypr_border -eq 0 ] && echo "5" || echo $hypr_border)

#// clipboard action

case "${1}" in
c|-c|--copy)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Copy...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" | cliphist decode | wl-copy
    ;;
d|-d|--delete)
    cliphist list | rofi -dmenu -theme-str "entry { placeholder: \"Delete...\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}" | cliphist delete
    ;;
w|-w|--wipe)
    if [ $(echo -e "Yes\nNo" | rofi -dmenu -theme-str "entry { placeholder: \"Clear Clipboard History?\";}" -theme-str "${r_scale}" -theme-str "${r_override}" -config "${roconf}") == "Yes" ] ; then
        cliphist wipe
    fi
    ;;
*)
    echo -e "cliphist.sh [action]"
    echo "c -c --copy    :  cliphist list and copy selected"
    echo "d -d --delete  :  cliphist list and delete selected"
    echo "w -w --wipe    :  cliphist wipe database"
    exit 1
    ;;
esac
