#!/bin/bash

# find a random wallpaper that isn't the current wallpaper
WALLPAPER_DIR="$HOME/Wallpapers/"
CURRENT_WALL=$(swww query | grep 'currently displaying:' | sed -E 's/.*image: //')
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# reload wallpaper
swww img --transition-type wipe --transition-angle 30 --transition-step 200 "$WALLPAPER"

hyprctl hyprpaper reload ,"$WALLPAPER"

# Generate pywal colors
wal -i "$WALLPAPER"

# retrieve pywal colors
source ~/.cache/wal/colors.sh

# cat fuzzel config
cat > ~/.config/fuzzel/fuzzel.ini <<EOF
[main]
prompt="> "
font=JetBrainsMono Nerd Font:size=10
width=40
lines=5
horizontal-pad=26
vertical-pad=16
inner-pad=5
border-width=5
border-radius=5
anchor=center
icons-enabled=no
line-height=24

[colors]
background=${background}ff
text=${foreground}ff
prompt=${color4}ff
placeholder=${color7}ff
input=${foreground}ff
match=${color1}ff
selection=${foreground}ff
selection-text=${background}ff
selection-match=${color10}ff
border=${foreground}ff
EOF

# hyprlock & hyprland
OUT="$HOME/.config/hypr/colors.conf"
TMP="$(mktemp)"

# Create the .conf file
cat > "$TMP" <<EOF
\$WALLPAPER=$WALLPAPER
\$background=rgba(${background:1}ff)
\$foreground=rgba(${foreground:1}ff)
EOF

mv "$TMP" "$OUT"
