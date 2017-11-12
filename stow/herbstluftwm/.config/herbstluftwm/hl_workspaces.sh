#!/usr/bin/env bash

greenfg="%{F#9FBC00}"
greenbg="%{B#9FBC00}"
redfg="%{F#ff0000}"
redbg="%{B#ff0000}"
blackbg="%{B#222}"
blackfg="%{F#222}"
greyfg="%{F#8c8c8c}"
greybg="%{B#8c8c8c}"
reset="%{F-}%{B-}"

output=
IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status)"
for i in "${tags[@]}" ; do
    case ${i:0:1} in
        '#') # viewed on the specified monitor and focused
            output+="$greenbg$blackfg ${i:1} $reset"
            ;;
        ':') # not empty
            output+="$blackbg ${i:1} $reset"
            ;;
        '!') # contains an urgent window
            output+="$redbg$blackfg ${i:1} $reset"
            ;;
        *) # anything else (especially empty tags)
            output+="$blackbg$greyfg ${i:1} $reset"
            ;;
    esac
done

echo "$output"
