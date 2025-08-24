#!/bin/sh
echo "This is meant for Ubuntu-22"
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

sudo apt install git \
curl \
wget \
cmake \
build-essential \
vim \
neovim \
wireshark \
tcpdump \
net-tools \
gparted \
openssh-client \
openssh-server \
nmap \
chromium-browser \
gnome-tweaks \
tmux \
dbus-x11 \
libreoffice \
btop \
bat \
fonts-powerline lm-sensors \
-y

# Atuin for better history or use CTRL+R
# - synth-wave provides better history so you can ignore that tool and use CTRL+R
# btop > htop > top
# bat > cat
# dbus-x11 so we can bring in our terminal profile
# zellij > tmux ??
# Install latest nvim
# fonts-powerline and lm-sensors for synth-shell

wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xvf nvim-linux-x86_64.tar.gz
sudo cp -r nvim-linux-x86_64/* /usr/
sudo rm -rf nvim-linux-x86_6*

# Install cargo
curl https://sh.rustup.rs -sSf | sh

# Add in git branch & add in rust source by default to .bashrc
echo '
# Git Branch
function git_branch {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -x $branch ]; then 
      echo ""
    else 
      echo "($branch)"
    fi
}

. "$HOME/.cargo/env"
' >> ~/.bashrc

# I use snap becuase apt is v2.10 and snap has v3.0+
sudo snap install gimp

# Codium
# Ubuntu 24+
#echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
#| sudo tee /etc/apt/sources.list.d/vscodium.sources
# Ubuntu 22
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

# Add docker install
# Ensure system is up to date
sudo apt update -y && sudo apt upgrade -y
# Install required applications for docker & this process
sudo apt install git apt-transport-https ca-certificates curl gnupg lsb-release -y 
# Fetch docker keyring to verify docker apt package version 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Add docker to apt so we can install it
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/docker.list
# Clean out docker in case one exists
sudo rm /etc/apt/sources.list.d/docker.list
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# Install docker
sudo apt update
sudo apt install docker-ce docker-compose -y
# Setup docker group & link to user
sudo usermod -aG docker $USER
newgrp docker

# neovim config
cp -r ./include/nvim ~/.config/
mkdir AnonymousPro/
cd AnonymousPro
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AnonymousPro.zip
unzip AnonymousPro.zip
rm -rf AnonymousPro.zip
cd ../
mv AnonymousPro/ ~/.fonts/
rm -rf ~/.fonts/AnonymousPro/OFL.txt 
rm -rf ~/.fonts/AnonymousPro/README.md 

# Set the terminal color
dconf load /org/gnome/terminal/legacy/profiles:/ < ./include/terminal-profile.dconf
dconf write /org/gnome/terminal/legacy/profiles:/default "b1acd1cc-5182-4d8d-a863-c796e6d879b9"

# Terminal color preferences
git clone --recursive https://github.com/andresgongora/synth-shell.git
cd synth-shell
./setup.sh

# Create scripts
sudo ln -s /opt/scripts/bmake.sh           /usr/bin/bmake
sudo ln -s /opt/scripts/check-connect.sh   /usr/bin/check-connect
sudo ln -s /opt/scripts/cleanup.sh         /usr/bin/cleanup
sudo ln -s /opt/scripts/del-docker.sh      /usr/bin/del-docker
sudo ln -s /opt/scripts/grefresh.sh        /usr/bin/grefresh
sudo ln -s /opt/scripts/mount-vm.sh        /usr/bin/mount-vm
sudo ln -s /opt/scripts/string-replace.sh  /usr/bin/string-replace

# Cleanup
sudo apt autoremove -y
sudo apt autoclean -y
