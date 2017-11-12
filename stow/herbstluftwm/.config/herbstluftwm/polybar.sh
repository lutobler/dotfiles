#!/usr/bin/env bash

cleanup() {
    kill ${pids[@]} 2> /dev/null
    wait 2> /dev/null
    exit 0
}
trap cleanup INT TERM HUP

herbstclient pad 0 18
polybar -c ~/.config/herbstluftwm/polybar_config hlwm-top &
pids=( $! )

event_handler() {
    while :; do
        IFS=$'\t' read -ra cmd || break
        case "${cmd[0]}" in
            tag*)
                polybar-msg hook hlws 1
                ;;
        esac
    done
}

herbstclient --idle | event_handler 2>&1 >/dev/null


