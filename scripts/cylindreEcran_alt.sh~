#!/bin/bash

#calculate total width of all screens
let "totalWidth = -1"
let "numOfScreens = -1"
for size in $(xrandr | grep -w connected  | awk -F'[ +]' '{print $3}' | cut -d x -f 1)
do
  let "totalWidth += $size"
  let "numOfScreens += 1"
done

while true 
do
    #get mouse position
    mdata=`xdotool getmouselocation`

    #extract x/y coordinates
    mx=`echo "$mdata"|cut -f1 -d' '|cut -d: -f2`
    my=`echo "$mdata"|cut -f2 -d' '|cut -d: -f2`

    #check for position and if at either left or right edge, move the mouse
    if [ $mx == $totalWidth ]; then
        xdotool mousemove 1 $my 
    elif [ $mx == 0 ]; then
 xdotool mousemove --screen $numOfScreens $totalWidth $my
    fi
done
