#!/bin/bash


# disable screen blanking
xset s off
xset -dpms

# remove the cursor
/usr/bin/unclutter -root -grab -idle 1 -reset &

/usr/local/bin/changeomatic start

openbox-session

