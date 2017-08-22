#!/bin/sh

[[ -f "$HOME/.Xresources" ]] && xrdb -merge "$HOME/.Xresources"

urxvtd -q -f -o &
redshift &
nm-applet &
unclutter -idle 3 &

xset +fp $HOME/.fonts
setxkbmap ch

exec awesome
