#!/usr/bin/env bash 

HDMI=$(xrandr --listmonitors | grep HDMI)

xrandr --auto
xrandr --output HDMI-1-0 --mode 3440x1440 --rate 100

if ! [[ -z $HDMI ]]; then
    xrandr --auto --output eDP-1 --left-of HDMI-1-0
fi 



