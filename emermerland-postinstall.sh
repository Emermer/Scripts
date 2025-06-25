#!/bin/bash

set -e

GREEN='\033[1;32m'
NC='\033[0m'

USERNAME=$(logname)

echo -e "${GREEN}>> Updating system...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${GREEN}>> Enabling colored output and ILoveCandy in pacman.conf...${NC}"
sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
if ! grep -q '^ILoveCandy' /etc/pacman.conf; then
  sudo sed -i '/^\[options\]/a ILoveCandy' /etc/pacman.conf
fi

echo -e "${GREEN}>> Installing paru...${NC}"
sudo pacman -S --needed --noconfirm git base-devel
cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si --noconfirm

echo -e "${GREEN}>> Installing packages with paru...${NC}"
paru -S --noconfirm \
  adobe-source-code-pro-fonts \
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
  lib32-gamemode \
  gcolor3 \
  gedit \
  gimp \
  gnome-disk-utility \
  goverlay \
  gparted \
  gtklock-powerbar-module \
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
  librewolf-bin \
  lutris \
  lxappearance \
  lxsession \
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
  qt5ct \
  qt6ct \
  r2modman-bin \
  rnnoise \
  rofi-lbonn-wayland-git \
  rpcs3-git \
  sassc \
  sddm \
  simple-and-soft-cursor \
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
  waybar \
  webcord-bin \
  wireless_tools \
  wlogout-git \
  wlr-randr \
  wlroots0.18 \
  xf86-video-amdgpu \
  xf86-video-ati \
  xorg-xinit \
  xwaylandvideobridge \
  yt-dlp \
  zip \
  zram-generator \
  zsh \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  zsh-theme-powerlevel10k-git

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

echo -e "${GREEN}>> Cloning dotfiles and copying .config and home files...${NC}"
cd ~"$USERNAME"
git clone https://github.com/Emermer/Mydotfiles.git

# Copy .config folder
cp -r Mydotfiles/.config ~"$USERNAME"/

# Copy files from HOME folder to ~
cp -r Mydotfiles/HOME/. ~"$USERNAME"/

# Set correct ownership
chown -R "$USERNAME":"$USERNAME" ~"$USERNAME"/.config
chown -R "$USERNAME":"$USERNAME" ~"$USERNAME"/

# Clean up
rm -rf Mydotfiles

echo -e "${GREEN}>> Setting Zsh as the default shell for $USERNAME...${NC}"
sudo chsh -s /bin/zsh "$USERNAME"

echo -e "${GREEN}>> Configuring NetworkManager to use iwd as backend...${NC}"
sudo mkdir -p /etc/NetworkManager/conf.d
echo -e "[device]\nwifi.backend=iwd" | sudo tee /etc/NetworkManager/conf.d/wifi_backend.conf
sudo systemctl enable --now iwd.service

echo -e "${GREEN}>> Creating /etc/sddm.conf for autologin as $USERNAME...${NC}"
echo -e "[Autologin]\nUser=$USERNAME\nSession=hyprland" | sudo tee /etc/sddm.conf

echo -e "${GREEN}>> Enabling SDDM login manager...${NC}"
sudo systemctl enable sddm

echo -e "${GREEN}>> Setting timeout=0 in /boot/loader/loader.conf...${NC}"
echo "timeout 0" | sudo tee /boot/loader/loader.conf

echo -e "${GREEN}>> Adding 'loglevel=3' to all .conf files in /boot/loader/entries...${NC}"
for file in /boot/loader/entries/*.conf; do
  if ! grep -q 'loglevel=3' "$file"; then
    echo "loglevel=3" | sudo tee -a "$file"
  fi
done

echo -e "${GREEN}>> Setup complete! Reboot or log out to apply all changes.${NC}"
