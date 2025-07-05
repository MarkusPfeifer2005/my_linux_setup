#!/bin/bash

# This shell script removes GNOME games and other potential bloatware.
# Please review each section before executing the commands.

# List of GNOME games to remove
gnome_games=(
    "aisleriot"       # Solitaire Card Games
    "gnome-mahjongg"  # Mahjongg game
    "gnome-mines"     # Minesweeper game
    "gnome-sudoku"    # Sudoku game
    "gnome-klotski"   # Klotski sliding puzzle game
    "gnome-nibbles"   # Nibbles game
    "gnome-robots"    # Robots game
    "gnome-tetravex"  # Tetravex puzzle game
    "quadrapassel"    # Tetris-like game
    "lightsoff"       # Lights Off puzzle game
    "swell-foop"      # Space-themed game
    "tali"            # Puzzle game
    "gnome-2048"      # 2048 game
    "five-or-more"    # Puzzle game
    "hitori"          # Hitori puzzle game
    "iagno"           # Reversi game
)

# List of other potential bloatware to remove
bloatware=(
    "gnome-maps"      # Maps application
    "gnome-contacts"  # Contacts application
    "gnome-calendar"  # Calendar application
    "gnome-characters" # Character map application
    "gnome-logs"       # System logs viewer
    "gnome-todo"       # Personal task manager
    "gnome-boxes"      # Simple application to access remote or virtual systems
    "gnome-documents"  # Documents viewer
    "gnome-photos"     # Photos application
    "gnome-music"      # Music player
    "gnome-clocks"     # Clocks application
    "gnome-recipes"    # Recipes application
    "cheese"           # Webcam application
    "rhythmbox"        # Music player
    "shotwell"         # Photo manager
    "evolution"        # Email and calendar application
    "totem"            # Video player
)

# Function to remove packages
remove_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        echo "Removing $package..."
        sudo apt-get remove -y "$package"
    done
}

# Remove GNOME games
echo "Removing GNOME games..."
remove_packages "${gnome_games[@]}"

# Remove other potential bloatware
echo "Removing other potential bloatware..."
remove_packages "${bloatware[@]}"

# End of script
echo "Cleanup completed."
