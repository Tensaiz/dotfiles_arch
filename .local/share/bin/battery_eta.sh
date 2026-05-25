#!/bin/bash

BAT=/sys/class/power_supply/BAT0
CACHE=/tmp/battery_eta

PCT=$(cat "$BAT/capacity")
STATUS=$(cat "$BAT/status")
NOW=$(date +%s)

# Save sample
echo "$NOW $PCT $STATUS" >> "$CACHE"
tail -n 50 "$CACHE" > "${CACHE}.tmp"
mv "${CACHE}.tmp" "$CACHE"

# Charging
if [ "$STATUS" = "Charging" ]; then
    echo "⚡"
    exit
fi

# Need enough history
FIRST=$(head -1 "$CACHE")
LAST=$(tail -1 "$CACHE")

T1=$(echo "$FIRST" | awk '{print $1}')
P1=$(echo "$FIRST" | awk '{print $2}')

T2=$(echo "$LAST" | awk '{print $1}')
P2=$(echo "$LAST" | awk '{print $2}')

DT=$((T2-T1))
DP=$((P1-P2))

# Wait until enough discharge observed
if [ "$DT" -lt 300 ] || [ "$DP" -le 0 ]; then
    echo "${PCT}%"
    exit
fi

SECONDS=$((PCT * DT / DP))

H=$((SECONDS/3600))
M=$(((SECONDS%3600)/60))

echo "${PCT}% ${H}h ${M}m"
