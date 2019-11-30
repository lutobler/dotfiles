#!/usr/bin/env bash

# depends on: inotify-tools

dir=~/downloads

mkdir -p $dir/pdf
mkdir -p $dir/iso
mkdir -p $dir/archives
mkdir -p $dir/videos
mkdir -p $dir/pictures

while fname=$(inotifywait --format %f -q -e create $dir); do
    file="$dir/$fname"
    case "$file" in
        *.pdf)
            mv "$file" $dir/pdf
            ;;
        *.iso|*.img)
            mv "$file" $dir/iso
            ;;
        *.png|*.jpg|*.gif|*.jpeg|*.svg)
            mv "$file" $dir/pictures
            ;;
        *.zip|*.zipx|*.rar|*.tar|*.bz2|*.gz|*.lz|*.lzma|*.lzo|*.sz|*.xz|\
            *.7z|*.apk|*.tgz|*.Z|*.tbz2|*.tlz|*.zz)
            mv "$file" $dir/archives
            ;;
        *.avi|*.AVI|*.mpg|*.MPG|*.mpeg|*.mpv|*.mp4|*.MP4|*.mkv|*.MKV|*.webm|\
            *.flv|*.gifv|*.mov|*.m4p|*.m4v|*.flv)
            mv "$file" $dir/videos
            ;;
    esac
done
