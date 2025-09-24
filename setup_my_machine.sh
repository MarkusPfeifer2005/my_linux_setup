#!/bin/bash

function printHeader () {
    echo -e "\e[34m${1}\e[0m"
}

# the following sudo install and configuration is not necessary if
# you opted to lock the root user and automatically add your user
# to the sudoers file
# https://wiki.debian.org/sudo?action=show&redirect=Sudo
# username="markus"
# apt install sudo
# sudo adduser $username sudo

if [ "$XDG_SESSION_TYPE" = "x11" ]
then
    echo "You are on X11!"
    sudo apt install i3 lightdm -y
elif [ "$XDG_SESSION_TYPE" = "wayland" ]
then
    echo "You are on Wayland!"
    sudo apt install sway waybar -y
fi
# lxappearance to switch to dark mode (might require installation of gnome-themes-extra)
# lxappearance edits ~/.config/gtk-3.0/settings.ini
sudo apt install \
	firefox-esr\
	thunderbird\
    lxappearance\
    alacritty\
    build-essential\
    git\
    gh\
    curl\
    freecad\
    ldraw-parts\
    texstudio\
    keepassxc\
    feh\
    mpv\
    zip\
	scrot\
    xournalpp\
    -y

sudo apt install vim -y
sudo apt install nodejs npm -y  # for vim plugins
sudo apt install clangd -y  # for vim C++ language server
sudo apt install vim-gtk3 -y  # for vim copying to things like firefox
sudo apt install golang -y  # for vim YouCompleteMe
vim +"CocInstall -sync coc-clangd coc-pyright|q"  # calls the commands inside of vim

# setup Bluetooth
sudo apt install pipewire libspa-0.2-bluetooth -y
sudo apt purge pulseaudio-module-bluetooth -y

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

# https://code.visualstudio.com/docs/setup/linux
printHeader "installing VS Code"
#echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg
sudo cat << EOF > /etc/apt/sources.list.d/vscode.sources
Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
EOF
sudo apt install apt-transport-https -y
sudo apt update
sudo apt install code -y # or code-insiders


printHeader "installing signal"
wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
cat signal-desktop-keyring.gpg | sudo tee /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' | sudo tee /etc/apt/sources.list.d/signal-xenial.list
sudo apt update
sudo apt install signal-desktop -y

# https://www.spotify.com/de-en/download/linux/
printHeader "installing spotify"
curl -sS https://download.spotify.com/debian/pubkey_6224F9941A8AA6D1.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get install spotify-client -y

# vimplug see: https://github.com/junegunn/vim-plug?tab=readme-ov-file
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
