#!/bin/bash

# Update System
sudo pacman -Syu

# Install i3-gaps
sudo pacman -S i3-gaps

# Install Apps
sudo pacman -S terminator krusader firefox steam lutris rofi discord virtualbox awesome-terminal-fonts flameshot nitrogen lxappearance arandr pamac pamac-gtk galculator gnome-disk-utility gimp gparted htop libreoffice-fresh dolphin-emu gufw gcolor2 lightdm-gtk-greeter lightdm-gtk-greeter-settings mpv obs-studio piper viewnior vlc wine winetricks neofetch cmatrix etcher timeshift-gtk nano nano-syntax-highlighting networkmanager 

# VirtualBox Ext Pack Git Clone
git clone https://aur.archlinux.org/virtualbox-ext-oracle.git
cd virtualbox-ext-oracle
makepkg -si
cd

# Enable USB 3.0 Support For Virtualbox
sudo usermod -aG vboxusers emermer

# Bumblebee-status Install
git clone https://aur.archlinux.org/bumblebee-status.git
cd bumblebee-status
makepkg -sicr
cd

# Powerline Fonts Install
# clone
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
./install.sh
# clean-up a bit
cd ..
rm -rf fonts
cd

# MS Fonts Install
git clone https://aur.archlinux.org/ttf-ms-fonts.git
cd ttf-ms-fonts
makepkg -si
cd

# i3 Config
cd .config
git clone https://github.com/Emermer/i3
cd

# Picom Install
yay -S picom-git

echo Reboot
