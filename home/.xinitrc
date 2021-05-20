#!/usr/bin/env sh

#. $HOME/.xprofile        #run from bspwm config

#xbacklight -set 30% &
xset -b &
xtrlock -f &
exec dbus-launch spectrwm
