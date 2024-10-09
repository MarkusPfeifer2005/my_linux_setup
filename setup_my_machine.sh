#!/bin/bash

function printHeader () {
echo -e "\e[34m${1}\e[0m"
}

username="markus"
# https://wiki.debian.org/sudo?action=show&redirect=Sudo
apt install sudo
sudo adduser $username sudo

# https://unix.stackexchange.com/questions/32793/how-to-remove-gnome-games-package-without-removing-other-packages
# https://unix.stackexchange.com/questions/691386/remove-preinstalled-gnome-applications
printHeader "removing games"
sudo apt remove gnome-games -y
sudo apt remove gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-robots gnome-nibbles gnome-sudoku hitori lightsoff quadrapassel iagno tali gnome-taquin gnome-tetravex swell-foop -y
printHeader "removing applications"
sudo apt remove gnome-characters gnome-calculator gnome-music cheese gnome-calendar gnome-contacts gnome-music gnome-maps gnome-clocks simple-scan evince gnome-sound-recorder rhythmbox shotwell yelp evolution gnome-logs file-roller gnome-disk-utility baobab gnome-font-viewer seahorse gnome-system-monitor -y
sudo apt remove im-config transmission-gtk synaptic software-properties-gtk -y
# to continue using gnome keep network-manager-gnome
sudo apt autoremove -y

# https://youtu.be/h8opVWdDPXM?t=278
sudo apt install i3 lightdm x11-xserver-utils nm-tray -y
# lxappearance to switch to dark mode (might require installation of gnome-themes-extra)
# lxappearance edits ~/.config/gtk-3.0/settings.ini
sudo apt install firefox-esr lxappearance gnome-terminal build-essential git curl -y
sudo apt install freecad leocad ldraw-parts texstudio keepassxc feh mpv -y

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

printHeader "installing PyCharm"
if find "/home/${username}/.local/share" -maxdepth 1 -type "d" -name "pycharm-*" | grep -q .; then
	echo "PyCharm is already installed!"
else
	echo "Installing PyCharm..."
	original_dir=$( pwd )
	cd "/home/${username}/.local/share/"
	wget https://download.jetbrains.com/python/pycharm-professional-2024.1.4.tar.gz
	tar -xf pycharm-professional-2024.1.4.tar.gz
	rm pycharm-professional-2024.1.4.tar.gz
	cd $original_dir
fi
if ! find "/usr/local/bin" -maxdepth 1 -type "f" -name "pycharm" | grep -q .; then
	file="/usr/local/bin/pycharm"
	echo "creating pycharm starter file at ${file}"
	touch $file
	echo "#!/bin/bash">>$file
	echo "exec /home/${username}/.local/share/pycharm-2024.1.4/bin/pycharm.sh">>$file
        sudo chmod +x $file
fi

# https://code.visualstudio.com/docs/supporting/faq#_how-do-i-find-the-version
printHeader "installing vscode"
if [ $(which code) = "/usr/bin/code" ]; then
	echo "vscode already installed"
else
	original_dir=$( pwd )
	cd "/home/${username}/Downloads"
	installation_file="vscode.deb"
	wget https://update.code.visualstudio.com/latest/linux-deb-x64/stable -O $installation_file
	sudo apt install "./${installation_file}"
	rm $installation_file
	cd $original_dir
fi

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
