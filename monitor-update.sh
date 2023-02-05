#!/usr/bin/env bash 

HDMI=$(xrandr --listmonitors | grep HDMI)

xrandr --auto

if ! [[ -z $HDMI ]]; then
    xrandr --auto --output eDP-1-1 --left-of HDMI-0
fi 



