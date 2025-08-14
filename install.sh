SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "## Installing programs ##"
sudo pacman -S --needed hyprland kitty fuzzel swww hyprlock waybar mako nwg-bar hyprshot fzf network-manager-applet leafpad nautilus

echo "## Installing fonts ##"
sudo pacman -S --needed ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-cjk

echo "## Setting up bluetooth ##"
sudo pacman -S --needed bluez bluez-utils blueman
sudo systemctl enable --now bluetooth.service

echo "## Setting up audio ##"
sudo pacman -S --needed pipewire wireplumber pavucontrol pipewire-pulse pipewire-alsa 
sudo systemctl --user enable --now pipewire
sudo systemctl --user enable --now wireplumber

if ! pacman -Q paru &>/dev/null; then
  echo "## Installing paru ##"
  mkdir -p ~/builds
  git clone https://aur.archlinux.org/paru.git ~/builds/paru
  cd ~/builds/paru && makepkg -si --noconfirm
fi

echo "## Installing zen-browser and pywal16 ##"
paru -S --needed zen-browser-bin python-pywal16

DIRS=(
  ".config/hypr"
  ".config/fuzzel"
  ".config/mako"
  ".config/waybar"
  ".config/nwg-bar"
  ".config/kitty"
  ".config/wal"
  ".cache/wal"
  ".scripts"
  "Pictures/Wallpapers"
)

echo "## Copying dotfiles ##"
for dir in "${DIRS[@]}"; do
  cp -r "$SCRIPT_DIR/$dir" "$HOME/$dir"
done

echo "## Making .scripts files executable ##"
chmod +x ~/.scripts/change-wp.sh
chmod +x ~/.scripts/cliphist-fuzzel-img

echo "## Setting up random theme ##"
~/.scripts/change-wp.sh

echo "## Symlinking fuzzel and mako configs ##"
ln -sf ~/.cache/wal/colors-fuzzel.ini ~/.config/fuzzel/fuzzel.ini
ln -sf ~/.cache/wal/colors-mako ~/.config/mako/config

echo "## Setting up themes ##"
mkdir -p "$SCRIPT_DIR"/themes

git clone https://github.com/vinceliuice/Tela-circle-icon-theme
cd "$SCRIPT_DIR"/themes/Tela-circle-icon-theme
./install.sh black

git clone https://github.com/vinceliuice/Graphite-gtk-theme 
cd "$SCRIPT_DIR"/themes/Graphite-gtk-theme
./install.sh -c dark --tweaks darker rimless

