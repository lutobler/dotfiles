#!/bin/sh

[[ -f "$HOME/xresources/.Xresources" ]] && xrdb -merge "$HOME/xresources/.Xresources"
[[ -f "$HOME/.Xresources" ]] && xrdb -merge "$HOME/.Xresources"

urxvtd -q -f -o &
redshift &
nm-applet &
unclutter -idle 3 &
$HOME/scripts/dowloads_watcher.sh &

xset +fp $HOME/.fonts
setxkbmap ch

exec awesome
