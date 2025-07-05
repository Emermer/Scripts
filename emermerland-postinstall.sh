#!/bin/bash

set -e

GREEN='\033[1;32m'
NC='\033[0m'

USERNAME=$(logname)

# System update
echo -e "${GREEN}>> Updating system...${NC}"
sudo pacman -Syu --noconfirm

# Pacman visuals
echo -e "${GREEN}>> Enabling colored output and ILoveCandy in pacman.conf...${NC}"
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi

# Install paru
echo -e "${GREEN}>> Installing paru...${NC}"
sudo pacman -S --needed --noconfirm git base-devel
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

# Install packages with paru
echo -e "${GREEN}>> Installing packages with paru...${NC}"
paru -S --noconfirm \
  adobe-source-code-pro-fonts \
  adw-gtk-theme \
  alacritty \
  alsa-utils \
  amd-ucode \
  arc-gtk-theme \
  autojump \
  base \
  bitwarden \
  blueman \
  bluez-utils \
  bridge-utils \
  cmus \
  corectrl \
  cpupower \
  debtap \
  deluge \
  docker \
  docker-compose \
  dunst \
  eww-git \
  fastfetch \
  flatpak \
  gammastep \
  gamescope \
  gamemode \
  gcolor3 \
  gedit \
  gimp \
  gnome-disk-utility \
  goverlay \
  gparted \
  grim \
  guestfs-tools \
  heroic-games-launcher-bin \
  htop \
  hyprland \
  hyprpicker \
  idlehack-git \
  imv \
  inter-font \
  jq \
  kdeconnect \
  layer-shell-qt \
  lib32-gamemode \
  lib32-mesa \
  lib32-vulkan-radeon \
  libreoffice \
  librewolf-bin \
  lutris \
  lxappearance \
  lxsession \
  mesa \
  mesa-utils \
  mugshot \
  musescore \
  musescore3-git \
  neofetch \
  nerd-fonts-sf-mono \
  network-manager-applet \
  nextcloud \
  noise-suppression-for-voice \
  nordic-theme \
  nwg-look-bin \
  openrgb \
  orchis-theme \
  otf-firamono-nerd \
  papirus-icon-theme \
  paru-git \
  pavucontrol \
  pinta \
  piper \
  protontricks \
  qalculate-gtk \
  qt5-wayland \
  qt5ct \
  qt6-wayland \
  qt6ct \
  r2modman-bin \
  rnnoise \
  rofi-wayland \
  rpcs3-git \
  sassc \
  sddm \
  simple-and-soft-cursor \
  slurp \
  smartmontools \
  spotube-bin \
  steam \
  swaybg \
  swayidle \
  thunar \
  timeshift \
  ttf-fantasque-nerd \
  ttf-font-awesome \
  ttf-iosevka-nerd \
  ttf-jetbrains-mono-nerd \
  ttf-nerd-fonts-symbols-common \
  ttf-noto-nerd \
  ufw \
  unrar \
  virt-manager \
  virt-viewer \
  vscodium-bin \
  vulkan-radeon \
  waybar \
  webcord-bin \
  wireless_tools \
  wlogout-git \
  wlr-randr \
  wlroots0.18 \
  xf86-video-amdgpu \
  xf86-video-ati \
  xdg-desktop-portal \
  xdg-desktop-portal-gtk \
  xdg-desktop-portal-hyprland \
  xorg-xinit \
  xwaylandvideobridge \
  yt-dlp \
  zip \
  zram-generator \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-theme-powerlevel10k-git

# Flatpak apps
echo -e "${GREEN}>> Installing Flatpak apps...${NC}"
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub \
  com.github.tchx84.Flatseal \
  com.obsproject.Studio \
  com.usebottles.bottles \
  com.github.Eloston.UngoogledChromium \
  io.mrarm.mcpelauncher \
  org.kde.kdenlive \
  org.polymc.PolyMC \
  dev.sober.Sober

# Dotfiles
cd ~"$USERNAME"
git clone https://github.com/Emermer/Mydotfiles.git
cp -r Mydotfiles/.config ~"$USERNAME"/
cp -r Mydotfiles/HOME/. ~"$USERNAME"/
chown -R "$USERNAME":"$USERNAME" ~"$USERNAME"/.config
chown -R "$USERNAME":"$USERNAME" ~"$USERNAME"/
rm -rf Mydotfiles

# Default shell
sudo chsh -s /bin/zsh "$USERNAME"

# Set CPU governor to performance mode
echo -e "${GREEN}>> Setting CPU governor to performance mode...${NC}"
sudo systemctl enable --now cpupower
echo "governor='performance'" | sudo tee /etc/default/cpupower

# NetworkManager + iwd
sudo mkdir -p /etc/NetworkManager/conf.d
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf
sudo systemctl enable --now iwd.service

# SDDM autologin
echo -e "[Autologin]\nUser=$USERNAME\nSession=hyprland" | sudo tee /etc/sddm.conf
sudo systemctl enable sddm

# Remove GRUB, install systemd-boot
sudo pacman -Rns --noconfirm grub grub-tools grub-theme* || true
sudo bootctl install

echo "timeout 0" | sudo tee /boot/loader/loader.conf

ROOT_PARTUUID=$(blkid -s PARTUUID -o value /dev/$(findmnt / -o SOURCE -n))

cat <<EOF | sudo tee /boot/loader/entries/arch.conf
title   Arch Linux
linux   /vmlinuz-linux
initrd  /amd-ucode.img
initrd  /initramfs-linux.img
options root=PARTUUID=$ROOT_PARTUUID rw loglevel=3
EOF

# Ensure loglevel=3 is present in all loader entries
for file in /boot/loader/entries/*.conf; do
  if ! grep -q 'loglevel=3' "$file"; then
    echo "loglevel=3" | sudo tee -a "$file"
  fi
done

echo -e "${GREEN}>> Setup complete! Reboot to start using your system.${NC}"
