#!/bin/bash
set -euo pipefail

# ----------------------------------------
# Essential packages
# ----------------------------------------
echo "Installing essential packages..."
sudo pacman -S --needed base-devel git rofi wget --noconfirm

# ----------------------------------------
# Create Git folder
# ----------------------------------------
GIT="$HOME/git"
mkdir -p "$GIT"

# ----------------------------------------
# Install yay (AUR helper)
# ----------------------------------------
if [ ! -d "$GIT/yay" ]; then
    git clone https://aur.archlinux.org/yay.git "$GIT/yay"
fi
cd "$GIT/yay"
makepkg -si --noconfirm

# ----------------------------------------
# Install Visual Studio Code from AUR
# ----------------------------------------
if [ ! -d "$GIT/visual-studio-code-bin" ]; then
    git clone https://aur.archlinux.org/visual-studio-code-bin.git "$GIT/visual-studio-code-bin"
fi
cd "$GIT/visual-studio-code-bin"
makepkg -si --noconfirm

# ----------------------------------------
# Install Python
# ----------------------------------------
yay -S --needed python --noconfirm

# ----------------------------------------
# Waybar setup
# ----------------------------------------
yay -S --needed waybar --noconfirm

# ----------------------------------------
# Backup existing configs
# ----------------------------------------
[ -d ~/.config/hypr ] && mv ~/.config/hypr ~/.config/hypr.bak
[ -d ~/.config/waybar ] && mv ~/.config/waybar ~/.config/waybar.bak
[ -d ~/.config/rofi ] && mv ~/.config/rofi ~/.config/rofi.bak

# ----------------------------------------
# Install BHlmaoMSD dotfiles
# ----------------------------------------
git clone https://github.com/BHlmaoMSD/dotfiles.git "$GIT/dotfiles"
cp -r "$GIT/dotfiles/.config/hypr" ~/.config/hypr
cp -r "$GIT/dotfiles/.config/waybar" ~/.config/waybar
cp -r "$GIT/dotfiles/.config/rofi" ~/.config/rofi

# ----------------------------------------
# Install dependencies
# ----------------------------------------
sudo pacman -S --needed hyprland waybar rofi foot dunst --noconfirm
yay -S --needed rofi-lbonn-wayland --noconfirm

# ----------------------------------------
# Make scripts executable
# ----------------------------------------
chmod +x ~/.config/hypr/scripts/* || true
chmod +x ~/.config/rofi/scripts/* || true

# ----------------------------------------
# Wallpaper setup
# ----------------------------------------
WALLPAPERS="$HOME/wallpapers"
mkdir -p "$WALLPAPERS"
cd "$WALLPAPERS"
wget -O blue-mountain.jpg https://backiee.com/static/wallpapers/1000x563/224663.jpg

# Install hyprpaper
sudo pacman -S --needed hyprpaper --noconfirm
mkdir -p ~/.config/hypr
cat > ~/.config/hypr/hyprpaper.conf <<EOF
preload = $WALLPAPERS/blue-mountain.jpg
wallpaper = , $WALLPAPERS/blue-mountain.jpg
splash = false
EOF

# ----------------------------------------
# User scripts folder
# ----------------------------------------
SCRIPTS="$HOME/scripts"
mkdir -p "$SCRIPTS"

# Hyprpaper setup script
cat > "$SCRIPTS/hyprpaper-setup.sh" <<'EOF'
#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
EOF

chmod +x "$SCRIPTS/hyprpaper-setup.sh"

echo "Setup complete! Dotfiles, Waybar, Hyprland, and Hyprpaper are installed."
echo "Log out and start a Hyprland session to see the changes."
sleep 5
hyprctl dispatch exit