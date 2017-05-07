#!/usr/bin/env bash

# a statusbar for herbstluftwm based on lemonbar

stalonetray &
pids+=( $! )

hc() { herbstclient "$@"; }

pids=(  )
monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
[ -n "$geometry" ] || { echo "Invalid monitor $monitor"; exit; }
x=${geometry[0]}
y=${geometry[1]}
width=$(( ${geometry[2]} - 36 )) # room for stalonetray
font="-xos4-terminus-medium-r-normal--12-120-72-72-c-60-iso10646-1"
height=18
update_interval=20
tag_style="text" # text, block

# global content variables
datetime=""
battery=""
temp=""
volume=""
muted=""
tags=""
linux=""

# colors
whitefg="%{F#ffffff}"
whitebg="%{B#ffffff}"
blackfg="%{F#000000}"
blackbg="%{B#000000}"
redfg="%{F#ff0000}"
redbg="%{B#ff0000}"
greenfg="%{F#9FBC00}"
greenbg="%{B#9FBC00}"
greyfg="%{F#8c8c8c}"
greybg="%{B#8c8c8c}"
stdcol="$whitefg$blackbg"

separator="$bgcolor%{F#ff0000}|$stdcol"

cleanup() {
    kill ${pids[@]} 2> /dev/null
    killall stalonetray
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
    read -ra pulsehook <<< "$($HOME/scripts/pulseaudioctl.sh hlwm_hook)"
    volume="${pulsehook[1]}"
    muted="${pulsehook[2]}"
    linux="LINUX $(uname -r)"
}

update_tags() {
    IFS=$'\t' read -ra tag_status <<< "$(hc tag_status $monitor)"
    tags=""

    if [[ "$tag_style" == "text" ]]; then
        for i in "${tag_status[@]}" ; do
            case ${i:0:1} in
                '#') # viewed on the specified monitor and focused
                    tags+="$blackbg$whitefg [${i:1}]$stdcol"
                    ;;
                ':') # not empty
                    tags+="$blackbg$greenfg [${i:1}]$stdcol"
                    ;;
                '!') # contains an urgent window
                    tags+="$redbg$blackfg [${i:1}]$stdcol"
                    ;;
                *) # anything else (especially empty tags)
                    tags+="$blackbg$greyfg [${i:1}]$stdcol"
                    ;;
            esac
        done
    elif [[ "$tag_style" == "block" ]]; then
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
    fi
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
        echo -n "$tags "
        echo -n "$separator  $stdcol"
        echo -n "$windowtitle"

        # right aligned
        echo -n "%{r}$stdcol"
        echo -n "$linux  $separator  "      # kernel version
        echo -n "$temp  $separator  "       # temperature
        echo -n "$battery  $separator  "    # battery

        # audio volume
        if [[ "$muted" != "muted" ]]; then
            echo -n "VOL $volume%  $separator  "
        else
            echo -n "VOL $volume% (muted)  $separator  "
        fi

        echo -n "$datetime "                # date/time
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
            pulseaudio_key)
                volume="${cmd[1]}"
                muted="${cmd[2]}"
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
