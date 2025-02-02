#!/bin/sh

# Автозапуск Waybar
waybar &

# Автозапуск фону
swaybg -i ~/Pictures/wallpaper.jpg &

# Автозапуск xwaylandvideobridge
xwaylandvideobridge &
