#!/usr/bin/env bash

hc() { herbstclient "$@"; }

pids=(  )
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
[ -n "$geometry" ] || { echo "Invalid monitor $monitor"; exit; }
x=${geometry[0]}
y=${geometry[1]}
width=${geometry[2]}
font="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"
height=17
update_interval=20

# global content variables
datetime=""
battery=""
temp=""
# volume=""
# muted=""
tags=""

# colors
whitefg="%{F#ffffff}"
whitebg="%{B#ffffff}"
blackfg="%{F#000000}"
blackbg="%{B#000000}"
redfg="%{F#ff0000}"
redbg="%{B#ff0000}"
greenfg="%{F#90c466}"
greenbg="%{B#90c466}"
greyfg="%{F#8c8c8c}"
greybg="%{B#8c8c8c}"
stdcol="$whitefg$blackbg"

separator="$bgcolor%{F#ff0000}|$stdcol"

cleanup() {
    kill ${pids[@]} 2> /dev/null
    wait 2> /dev/null
    exit 0
}
trap cleanup INT TERM HUP

bar_cmd() {
	lemonbar -g $width"x"$height"+"$x"+"$y -f "$font"
}

update_vars() {
    datetime=$(date +'%H:%M %Y-%m-%d')
	battery="BAT0: $(cat /sys/class/power_supply/BAT0/capacity)% / "
    battery+="BAT1: $(cat /sys/class/power_supply/BAT1/capacity)%"
    temp="CPU $(acpi -t | cut -d' ' -f4)°C"
}

update_tags() {
    IFS=$'\t' read -ra tag_status <<< "$(hc tag_status $monitor)"
    tags=""
    for i in "${tag_status[@]}" ; do
        case ${i:0:1} in
            '#') # viewed on the specified monitor and focused
                tags+="$greenbg$blackfg ${i:1} $stdcol"
                ;;
            ':') # not empty
                tags+="$blackbg$whitefg ${i:1} $stdcol"
                ;;
            '!') # contains an urgent window
                tags+="$redbg$blackfg ${i:1} $stdcol"
                ;;
            *) # anything else (especially empty tags)
                tags+="$blackbg$greyfg ${i:1} $stdcol"
                ;;
        esac
    done
}

event_generator() {
    while :; do
        hc emit_hook bar_update
        sleep $update_interval
    done
}

event_handler() {
    update_tags
    update_vars
    windowtitle=""

    while :; do

        # left aligned
        echo -n "%{l}"
        echo -n "$tags"
        echo -n " $separator  $stdcol"
        echo -n "$windowtitle"

        # right aligned
        echo -n "%{r}$stdcol"
        echo -n "$temp  $separator  "
        echo -n "$battery $separator  "
        echo -n "$datetime  "
        echo

        # wait for the next event
        IFS=$'\t' read -ra cmd || break

        case "${cmd[0]}" in
            tag*)
                update_tags
                ;;
            bar_update)
                update_vars
                ;;
            quit_panel|reload)
                return 0
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
        esac
    done
}

hc pad $monitor $height
event_generator &
pids+=( $! )

hc --idle | event_handler 2> /dev/null | bar_cmd

cleanup
