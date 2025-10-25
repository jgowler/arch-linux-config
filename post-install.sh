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
# Hyprland setup
# ----------------------------------------
mkdir -p ~/.config/hypr
cp /usr/share/hyprland/hyprland.conf ~/.config/hypr/hyprland.conf
hyprctl reload

# ----------------------------------------
# Install Visual Studio Code from AUR
# ----------------------------------------

yay -S github-desktop-bin --noconfirm

# ----------------------------------------
# Install Visual Studio Code from AUR
# ----------------------------------------

yay -S visual-studio-code-bin --noconfirm

# ----------------------------------------
# Install Python
# ----------------------------------------
yay -S --needed python --noconfirm

# ----------------------------------------
# Waybar setup
# ----------------------------------------
yay -S --needed waybar --noconfirm

# ----------------------------------------
# Reflector setup
# ----------------------------------------
yay -S reflector
systemctl start reflector.service
systemctl enable reflector.service

# ----------------------------------------
# mulitlib + Steam setup
# ----------------------------------------

if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/\[multilib\]/,/Include/ s/^#//' /etc/pacman.conf
fi

echo "Refreshing package database..."
sudo pacman -Syy

echo "Updating system packages..."
sudo pacman -Syu --noconfirm

pacman -Syu steam --noconfirm