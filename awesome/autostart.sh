#!/bin/sh

run() {
    if ! pgrep -f "$1"; then
        "$@" &
    fi
}

run "picom"
run "feh" --bg-scale ~/.wallpaper/hex.jpg
run "setxkbmap 'us,ru,ua' -option 'grp:alt_shift_toggle'"
