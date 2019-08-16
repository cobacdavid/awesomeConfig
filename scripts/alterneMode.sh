#!/bin/bash

b=`xrandr 2>/dev/null|grep -c "connected [^0-9]* [0-9x+]* left"`
#b=`xrandr 2>/dev/null|grep -c "connected [0-9x+]* left"`

if [ "$b" -eq 1 ]
then
    ## ligne pour la nvidia 7300 GS
    ## xrandr --output DVI-I-1 --rotate normal --output VGA-1 --right-of DVI-I-1
    ## ligne pour fglrx
    xrandr --output DFP1 --rotate normal --output CRT1 --right-of DFP1
    ## ligne pour le driver libre
    ##xrandr --output HDMI-0 --rotate normal --output VGA-0 --right-of HDMI-0
else
    ## ligne pour la nvidia 7300 GS
    ## xrandr --output DVI-I-1 --rotate left --output VGA-1 --right-of DVI-I-1
    ## ligne pour fglrx
    xrandr --output DFP1 --rotate left  --output CRT1 --right-of DFP1
    ## ligne pour le driver libre
    ##xrandr --output HDMI-0 --rotate left  --output VGA-0 --right-of HDMI-0
fi
