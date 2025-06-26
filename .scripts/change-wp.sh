#!/bin/bash

WALLPAPER_DIR="$HOME/Wallpapers"

if [ "$1" = "-p" ]; then
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f | fzf --preview 'kitty +kitten icat --clear --transfer-mode=file --stdin=no --place=108x44@0x0 {}' --preview-window=right:60%)

else
  # find a random wallpaper that isn't the current wallpaper
  CURRENT_WALL=$(swww query | grep 'currently displaying:' | sed -E 's/.*image: //') 
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1) 
fi

# if WALLPAPER variable is empty, nothing will be executed
[ -z "$WALLPAPER" ] && exit

# reload wallpaper
swww img --transition-type wipe --transition-angle 30 --transition-step 200 "$WALLPAPER"

# Generate pywal colors
wal -i "$WALLPAPER"

# retrieve pywal colors
source ~/.cache/wal/colors.sh

# reload mako
makoctl reload

# hyprlock & hyprland
OUT="$HOME/.config/hypr/colors.conf"
TMP="$(mktemp)"

# Create the .conf file
cat > "$TMP" <<EOF
\$WALLPAPER=$WALLPAPER
\$background=rgba(${background:1}ff)
\$foreground=rgba(${foreground:1}BF)
EOF

mv "$TMP" "$OUT"
