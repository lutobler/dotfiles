#!/bin/sh

try_merge() { [ -f "$1" ] && xrdb -merge "$1"; }
try_merge "$HOME/.config/xresources/Xresources"
try_merge "$HOME/xresources/Xresources"
try_merge "$HOME/.Xresources"

urxvtd -q -f -o &
redshift &
setxkbmap ch -option caps:swapescape
xset r rate 180 50
nm-applet &
protonmail-bridge &
$HOME/bin/downloads_watcher.sh &

exec herbstluftwm
