#!/bin/sh

xresources=(
    "$HOME/.config/xresources/Xresources"
    "$HOME/xresources/Xresources"
    "$HOME/.Xresources"
)

for x in "${xresources[@]}"; do
    [ -f "$x" ] && xrdb -merge "$x"
done

redshift &
setxkbmap ch -option caps:swapescape
xset r rate 180 50
nm-applet &
$HOME/bin/downloads_watcher.sh &

exec herbstluftwm

