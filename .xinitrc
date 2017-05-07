#!/bin/sh

[[ -f "$HOME/.Xresources" ]] && xrdb -merge "$HOME/.Xresources"

urxvtd -q -f -o &
redshift &
dunst &
~/scripts/wallpaper.sh &
unclutter -idle 3 &

xset +fp $HOME/.fonts
setxkbmap ch

exec herbstluftwm
