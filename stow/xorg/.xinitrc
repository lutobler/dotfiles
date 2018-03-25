#!/bin/sh

[ -f "$HOME/xresources/Xresources" ] && xrdb -merge "$HOME/xresources/Xresources"
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

urxvtd -q -f -o &
redshift &
nm-applet &
unclutter -idle 3 &
dunst &
$HOME/scripts/dowloads_watcher.sh &
$HOME/scripts/wallpaper.sh &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

xset +fp $HOME/.fonts
setxkbmap ch -option caps:swapescape

session=${2:-herbstluftwm}
case "$session" in
    awesome)
        exec awesome
        ;;
    herbstluftwm)
        exec herbstluftwm
        ;;
    i3)
        exec i3
        ;;
    *)
        echo "unknown WM"
        exit 1
        ;;
esac

