#!/bin/bash

export XDG_RUNTIME_DIR=/run/user/$(id -u)

V1="Charging"
V2=$(grep -w "Charging" /sys/class/power_supply/BAT0/status)
V3=$(grep -Eo '[0-9]{1,}' /sys/class/power_supply/BAT0/capacity)

#if [ "$V1" = "$V2" ] && [ "$V3" -ge 85 ]; then
#    notify-send -u critical "Remove Charger!"
#fi

U1="Discharging"
U2=$(grep -w "Discharging" /sys/class/power_supply/BAT0/status)
if [ "$U1" = "$U2" ] && [ "$V3" -ge 99 ]; then
    notify-send -u critical "Laptop on battery"
fi
