#!/usr/bin/env bash 

HDMI=$(xrandr --listmonitors | grep HDMI)

xrandr --auto
xrandr --output HDMI-0 --mode 3440x1440 --rate 100

if ! [[ -z $HDMI ]]; then
    xrandr --output HDMI-0 --off --output DP-0 --auto
    xrandr --output HDMI-0 --auto --output DP-0 --auto
    xrandr --auto --output DP-0 --left-of HDMI-0
fi 



