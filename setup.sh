#!/bin/bash
sudo pacman -Syu
sudo pacman -S git \
curl \
wget \
cmake \
vim \
neovim \
wireshark-qt \
tcpdump \
net-tools \
gparted \
openssh \
nmap \
tmux \
zsh \
libreoffice-fresh \
btop \
bat \
gdb \
xclip \
wget \
unzip \
tar \
gimp \ 
bc \
docker \
lm_sensors \
nvim \
alsa-utils \
pulseaudio \
pavucontrol

sudo systemctl enable docker
cp -r ./include/nvim/ ~/.config/

# photoqt and sonic visualizer have been removed
if [[ $(uname -a | tr '[:upper:]' '[:lower:]') == *virtual* ]]; then
  sudo pacman -S open-vm-tools -y
fi

# - synth-wave provides better history so you can ignore that tool and use CTRL+R
# btop > htop > top
# bat > cat
# fonts-powerline and lm-sensors for synth-shell
# Not adding zellij to replace tmux, gotta look into that app first

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
# install docker and chromium
# This adds the repo for chromium

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

# nvim in bash will look for this incorrectly
#ln -s ~/.local/share/nvim/nvchad/base46/ ~/.local/share/nvim/base46

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
sudo ln -s /opt/scripts/search-pptx.sh    /usr/bin/search-pptx

if [[ $(uname -a | tr '[:upper:]' '[:lower:]') == *virtual* ]]; then
  sudo ln -s /opt/scripts/mount-vm.sh /usr/bin/mount-vm
else
  sudo rm /opt/scripts/mount-vm.sh
fi

echo "Success, please reboot the device to complete the configuration ..."
