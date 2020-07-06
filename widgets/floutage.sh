#!/bin/bash

FILE=$1
X=$2
Y=$3
W=$4
H=$5
import -window root $FILE

mogrify -crop ${W}x${H}+${X}+${Y} -blur 150x50  $FILE
