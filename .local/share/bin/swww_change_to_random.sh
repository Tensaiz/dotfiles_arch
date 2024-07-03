#!/bin/bash

# This script will randomly select a single file from a directory and set it
# as the wallpaper, ensuring it does not select the currently selected wallpaper.
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

if [[ $# -lt 1 ]] || [[ ! -d $1 ]]; then
    echo "Usage:
    $0 <dir containing images>"
    exit 1
fi

# Edit below to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=2

# Get the current wallpaper paths
current_wallpapers=$(swww query | grep 'currently displaying: image:' | awk -F' ' '{print $NF}' | tr '\n' '|')

# Remove trailing pipe character
current_wallpapers=${current_wallpapers%|}

# Find all files in the specified directory, exclude the current wallpapers, and select one at random
img=$(find "$1" -type f | grep -Ev "${current_wallpapers//|/|}" | shuf -n 1)

# Check if a new image was found and set it as the wallpaper
if [[ -n "$img" ]]; then
    swww img "$img"
else
    echo "No new image found to set as wallpaper."
    exit 1
fi

