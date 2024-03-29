﻿#! /bin/bash

### XRANDR SETTINGS ###
xrandr --output DP-2 --mode 1680x1050 --pos 1920x30 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --rate 144 --pos 0x0 --rotate normal &

### PICOM ###
killall picom &
wait
picom &

### NITROGEN ###
nitrogen --restore &

### POLYBAR ###
killall -q polybar
echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
polybar bar1 2>&1 | tee -a /tmp/polybar1.log & disown
polybar bar2 2>&1 | tee -a /tmp/polybar2.log & disown

### KEY PRESS DELAY/RATE ###
xset r rate 250 25 &

### OTHER APPS ###
killall xautolock sxhkd flameshot nm-applet autotiling &
sleep 0.2
xautolock -time 5 -locker "betterlockscreen -l blur" &
sxhkd &
flameshot &
nm-applet &
autotiling &

### REDSHIFT ###
if pgrep redshift-gtk >/dev/null
then
    echo redshift already running
else
    redshift-gtk -c $HOME/.config/redshift/redshift.conf
fi &
