#!/bin/sh
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt install git curl wget cmake build-essential code vim neovim gimp wireshark tcpdump net-tools gparted openssh-client openssh-server nmap chromium-browser tmux -y

# Add docker config
# append .bashrc with git branch
# Terminal color preferences
# neovim config
# Window manager
# Setup gnome default apps
