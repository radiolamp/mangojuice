#!/bin/sh

set -e

icon_dir="${XDG_DATA_PREFIX:-/usr/share}/icons/hicolor"

if command -v gtk4-update-icon-cache >/dev/null 2>&1; then
    updater=gtk4-update-icon-cache
elif command -v gtk-update-icon-cache >/dev/null 2>&1; then
    updater=gtk-update-icon-cache
else
    echo "gtk4-update-icon-cache not found, skipping"
    exit 0
fi

if ! ls "$icon_dir"/*/apps/io.github.radiolamp.mangojuice*.svg >/dev/null 2>&1; then
    echo "mangojuice icons not installed in $icon_dir, skipping"
    exit 0
fi

"$updater" -f -t "$icon_dir"
