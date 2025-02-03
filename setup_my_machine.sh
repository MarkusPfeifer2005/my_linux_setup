#!/bin/bash

function printHeader () {
echo -e "\e[34m${1}\e[0m"
}

username="markus"
# https://wiki.debian.org/sudo?action=show&redirect=Sudo
apt install sudo
sudo adduser $username sudo

# https://youtu.be/h8opVWdDPXM?t=278
sudo apt install i3 lightdm x11-xserver-utils nm-tray -y
# lxappearance to switch to dark mode (might require installation of gnome-themes-extra)
# lxappearance edits ~/.config/gtk-3.0/settings.ini
sudo apt install firefox-esr lxappearance gnome-terminal build-essential git curl -y
sudo apt install freecad leocad ldraw-parts texstudio keepassxc feh mpv zip -y
sudo apt install scrot -y

# https://wiki.debian.org/NvidiaGraphicsDrivers#Debian_12_.22Bookworm.22
printHeader "installing nvidia drivers"
sudo apt install linux-headers-amd64
echo "deb http://deb.debian.org/debian/ bookworm contrib non-free">"/etc/apt/sources.list.d/nvidia.list"
sudo apt update
sudo apt install nvidia-detect -y
result=$(nvidia-detect)
if [ "$result" = "No NVIDIA GPU detected." ]; then
	echo $result
else
	sudo apt install nvidia-driver firmware-misc-nonfree
fi

# https://vscodium.com/#install-on-debian-ubuntu-deb-package
printHeader "installing VSCodium"
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt install codium -y

printHeader "installing signal"
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install signal-desktop

# https://www.spotify.com/de-en/download/linux/
printHeader "installing spotify"
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client
