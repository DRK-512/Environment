#!/bin/bash
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
openssh-known-hosts \
nmap \
gnome-tweaks \
tmux \
dbus-x11 \
libreoffice \
btop \
bat \
gdb \
fonts-powerline lm-sensors \
apt-transport-https ca-certificates gnupg lsb-release \
-y

if [[ $(uname -a | tr '[:upper:]' '[:lower:]') == *virtual* ]]; then
  sudo apt install open-vm-tools -y
else
  sudo add-apt-repository ppa:lumas/photoqt -y
  sudo apt-get install photoqt \
  libfishsound1 \
  libid3tag0 \
  liblo7 \
  liblrdf0 \
  libmad0 \
  liboggz2 \
  libopusfile0 \
  libqt6xml6 -y

  wget https://code.soundsoftware.ac.uk/attachments/download/2878/sonic-visualiser_5.2.1_amd64.deb
  sudo dpkg -i sonic-visualiser_5.2.1_amd64.deb
  sudo rm sonic-visualiser_5.2.1_amd64.deb
fi

# Atuin can be used for better history
# - synth-wave provides better history so you can ignore that tool and use CTRL+R
# btop > htop > top
# bat > cat
# dbus-x11 so we can bring in our terminal profile
# fonts-powerline and lm-sensors for synth-shell
# apt-transport-https ca-certificates gnupg lsb-release required for docker
# Not adding zellij to replace tmux, gotta look into that app first

# Install latest nvim
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar -xvf nvim-linux-x86_64.tar.gz
sudo cp -r nvim-linux-x86_64/* /usr/
sudo rm -rf nvim-linux-x86_6*

# Install cargo
curl https://sh.rustup.rs -sSf | sh

# Add in git branch & add in rust source by default to .bashrc
echo '
function git_branch {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -x $branch ]; then
    echo ""
  else
    echo "($branch)"
  fi
}
' >> ~/.bashrc

echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\e]0;\u@\h: \w\007\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[38;5;3m\]\$(git_branch)\[\033[00m\]\$ '" >> ~/.bashrc

# I use snap becuase apt is v2.10 and snap has v3.0+ and for gimp idc how long it takes to open
sudo snap install gimp

# Add Codium to apt
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
    | gpg --dearmor \
    | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
# Ubuntu 24+
#echo -e 'Types: deb\nURIs: https://download.vscodium.com/debs\nSuites: vscodium\nComponents: main\nArchitectures: amd64 arm64\nSigned-by: /usr/share/keyrings/vscodium-archive-keyring.gpg' \
#| sudo tee /etc/apt/sources.list.d/vscodium.sources
# Ubuntu 22
echo 'deb [arch=amd64,arm64 signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg] https://download.vscodium.com/debs vscodium main' \
    | sudo tee /etc/apt/sources.list.d/vscodium.list

# Add docker to apt
# Fetch docker keyring to verify docker apt package version 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
# Add docker to apt so we can install it
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/docker.list
# Clean out docker in case one exists
sudo rm /etc/apt/sources.list.d/docker.list
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# This adds the repo for chromium
sudo add-apt-repository ppa:xtradeb/apps -y

# Install docker and codium
sudo apt update
sudo apt install docker-ce docker-compose codium chromium -y

# Setup docker group & link to user
sudo usermod -aG docker $USER
newgrp docker

# neovim config
cp -r ./include/nvim ~/.config/
mkdir AnonymousPro/
cd AnonymousPro
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AnonymousPro.zip
unzip AnonymousPro.zip 
rm -rf AnonymousPro.zip OFL.txt README.md 
cd ../
[ ! -d ~/.fonts/ ] && mkdir ~/.fonts/
[ -d ~/.fonts/AnonymousPro ] && rm -rf ~/.fonts/AnonymousPro
mv AnonymousPro/ ~/.fonts/

# Set the terminal color
dconf load /org/gnome/ < ./include/gnome-profile.dconf

# Terminal color preferences
git clone --recursive https://github.com/andresgongora/synth-shell.git
cd synth-shell
git apply ../include/synth-shell-autoinstall.patch
./setup.sh
cd ..
rm -rf synth-shell

# Create scripts
sudo mkdir /opt/scripts
sudo chown -R $USER:$USER /opt/scripts
sudo cp ./include/scripts/* /opt/scripts

sudo ln -s /opt/scripts/bmake.sh          /usr/bin/bmake
sudo ln -s /opt/scripts/check-connect.sh  /usr/bin/check-connect
sudo ln -s /opt/scripts/cleanup.sh        /usr/bin/cleanup
sudo ln -s /opt/scripts/del-docker.sh     /usr/bin/del-docker
sudo ln -s /opt/scripts/grefresh.sh       /usr/bin/grefresh
sudo ln -s /opt/scripts/string-replace.sh /usr/bin/string-replace

if [[ $(uname -a | tr '[:upper:]' '[:lower:]') == *virtual* ]]; then
  sudo ln -s /opt/scripts/mount-vm.sh /usr/bin/mount-vm
else
  sudo rm /opt/scripts/mount-vm.sh
fi

# Cleanup
sudo apt autoremove -y
sudo apt autoclean -y

