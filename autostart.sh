#!/bin/bash

xrandr --output DP-2 --mode 1680x1050 --pos 1920x30 --rotate normal --output HDMI-1 --primary --mode 1920x1080 --rate 144 --pos 0x0 --rotate normal &

nitrogen --restore &

xset r rate 250 25 &

picom &
flameshot &
nm-applet &

if pgrep redshift-gtk >/dev/null
then
    echo redshift already running
else
    redshift-gtk -c $HOME/.config/redshift/redshift.conf
fi &
