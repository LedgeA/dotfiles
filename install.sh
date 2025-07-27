SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo pacman -S --needed swww hyprlock waybar mako nwg-bar hyprshot fzf
sudo pacman -S --needed ttf-font-awesome ttf-jetbrains-mono-nerd noto-fonts-cjk

echo "setting up bluetooth"
sudo pacman -S --needed bluez bluez-utils blueman
sudo systemctl enable --now bluetooth.service

echo "setting up audio"
sudo pacman -S --needed pipewire wireplumber pavucontrol pipewire-pulse pipewire-alsa 
sudo systemctl --user enable --now pipewire
sudo systemctl --user enable --now wireplumber

echo "installing and setting up git and paru"
mkdir -p ~/builds 
cd ~/builds 
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

if ! pacman -Q paru &>/dev/null; then
  echo "paru not found, installing..."
  mkdir -p ~/builds
  git clone https://aur.archlinux.org/paru.git ~/builds/paru
  cd ~/builds/paru && makepkg -si --noconfirm
fi

echo "installing zen-browser and pywal16"
paru -S --needed zen-browser-bin python-pywal16

DIRS=(
  ".config/hypr"
  ".config/fuzzel"
  ".config/mako"
  ".config/waybar"
  ".config/nwg-bar"
  ".config/kitty"
  ".config/wal"
  ".cache/wal" # 
  ".scripts"
)

echo "copying dotfiles"
for dir in "${DIRS[@]}"; do
  cp -r "$SCRIPT_DIR/$dir" "$HOME/"
done

echo "symlinking fuzzel and mako configs"
ln -sf ~/.cache/wal/colors-fuzzel.ini ~/.config/fuzzel/fuzzel.ini
ln -sf ~/.cache/wal/colors-mako ~/.config/mako/config

echo "making .scripts files executable"
chmod +x ~/.scripts/change-wp.sh
chmod +x ~/.scripts/cliphist-fuzzel-img
