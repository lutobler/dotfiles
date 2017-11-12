#!/usr/bin/env bash

greenfg="%{F#9FBC00}"
greenbg="%{B#9FBC00}"
redfg="%{F#ff0000}"
redbg="%{B#ff0000}"
background="%{B#222}"
foreground="%{F#222}"
reset="%{F-}%{B-}"

output=
IFS=$'\t' read -ra tags <<< "$(herbstclient tag_status)"
for i in "${tags[@]}" ; do
    case ${i:0:1} in
        '#') # viewed on the specified monitor and focused
            output+="$greenbg$foreground ${i:1} $reset"
            ;;
        ':') # not empty
            output+="$background ${i:1} $reset"
            ;;
        '!') # contains an urgent window
            output+="$redbg ${i:1} $reset"
            ;;
        *) # anything else (especially empty tags)
            output+="$background ${i:1} $reset"
            ;;
    esac
done

echo "$output"
