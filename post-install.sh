#!/bin/bash

# Install essential packages
sudo pacman -S --needed base-devel git rofi --noconfirm

# Create Git folder
mkdir -p "$HOME/git"

$GIT = "$HOME/git"

# Install yay (AUR helper)
cd "$HOME/git"
if [ ! -d "yay" ]; then
    git clone https://aur.archlinux.org/yay.git
fi
cd yay
sudo makepkg -si --noconfirm

# Install Visual Studio Code from AUR
cd "$HOME/git"
if [ ! -d "visual-studio-code-bin" ]; then
    git clone https://aur.archlinux.org/visual-studio-code-bin.git
fi
cd visual-studio-code-bin
makepkg -si --noconfirm
 
# Install Python:
yay -S python

# Install Hyprland theme:
cd $GIT
git clone https://github.com/coffebar/dotfiles.git
cd dotfiles
mv ~/.config/hypr ~/.config/hypr.bak
mv ~/.config/waybar ~/.config/waybar.bak
mv ~/.config/rofi ~/.config/rofi.bak
mv ~/.config/nvim ~/.config/nvim.bak
sudo pacman -S hyprland waybar rofi --noconfirm
