#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

if [ "$1" = "-p" ]; then
  wallpaper picker
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | fzf \
    --preview '
      kitty +kitten icat \
        --clear \
        --transfer-mode=file \
        --stdin=no \
        --place=$((COLUMNS))x$((LINES))@0x0 \
        {}
    ' \
    --preview-window=right:60%:wrap \
    --bind 'ctrl-r:toggle-preview+toggle-preview' \
    --header 'Refresh: Ctrl+R'
  )
else
  # find a random wallpaper that isn't the current wallpaper
  CURRENT_WALL=$(swww query | grep 'currently displaying:' | sed -E 's/.*image: //') 
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1) 
fi

# if WALLPAPER variable is empty, nothing will be executed
[ -z "$WALLPAPER" ] && exit

# Generate pywal colors
wal -i "$WALLPAPER" --cols16 lighten

# reload wallpaper
swww img --transition-type wipe --transition-angle 30 --transition-step 200 "$WALLPAPER" 

# reload mako
makoctl reload
