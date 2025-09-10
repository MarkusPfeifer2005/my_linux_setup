#!/bin/bash

# configuring the bash shell
newFile="$HOME/.bash_customisation"
cp config_files/bash_customisation "$newFile"
if ! grep -q "source $newFile" ~/.bashrc; then
    echo "source $newFile" >> ~/.bashrc
fi

# configuring alacritty
mkdir -p ~/.config/alacritty
if [ -z "$(ls ~/.config/alacritty)" ]; then
    wget https://raw.githubusercontent.com/alacritty/alacritty-theme/master/themes/blood_moon.toml -O ~/.config/alacritty/alacritty.toml
fi

# configuring i3
mkdir -p $HOME/.config/i3
cp config_files/i3/config $HOME/.config/i3/config

# configure vim
cp config_files/vimrc ~/.vimrc
