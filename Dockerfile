FROM ubuntu:22.04

RUN apt update -y && \
    apt upgrade -y && \
    apt dist-upgrade -y 

RUN apt install git \
sudo \
bc \
curl \
wget \
cmake \
build-essential \
vim \
neovim \
tcpdump \
net-tools \
openssh-client \
openssh-server \
openssh-known-hosts \
nmap \
tmux \
dbus-x11 \
btop \
bat \
gdb \
xclip \
unzip \
fonts-powerline \
lm-sensors \
pciutils \
-y

RUN useradd -m -s /bin/bash dev && \
    adduser dev sudo

# Nvim install
RUN wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz && \
    tar -xvf nvim-linux-x86_64.tar.gz && \
    cp -r nvim-linux-x86_64/* /usr/ && \
    rm -rf nvim-linux-x86_6* 

# Install cargo
RUN curl https://sh.rustup.rs -sSf > cargo-installer.sh && \
    chmod +x cargo-installer.sh && \
    ./cargo-installer.sh -y && \
    rm cargo-installer.sh

# Add in git branch & add in rust source by default to .bashrc
RUN echo -e '\nfunction git_branch {\n  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)\n  if [ -x $branch ]; then\n    echo ""\n  else\n    echo "($branch)"\n  fi\n}' >> ~/.bashrc
RUN sed -i "s/-e//g" ~/.bashrc
RUN echo "PS1='\${debian_chroot:+(\$debian_chroot)}\[\e]0;\u@\h: \w\007\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[38;5;3m\]\$(git_branch)\[\033[00m\]\$ '" >> ~/.bashrc

# Nvim font
COPY ./include /opt/include
RUN cp -r /opt/include/nvim ~/.config/ && \
    mkdir AnonymousPro/ && \
    cd AnonymousPro && \
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/AnonymousPro.zip && \
    unzip AnonymousPro.zip && \
    rm -rf AnonymousPro.zip OFL.txt README.md && \
    cd ../ && \
    mkdir ~/.fonts/ && \
    rm -rf ~/.fonts/AnonymousPro && \
    mv AnonymousPro/ ~/.fonts/

# nvim in bash will look for this incorrectly
#RUN ln -s ~/.local/share/nvim/nvchad/base46/ ~/.local/share/nvim/base46

# Terminal color preferences
RUN git clone --recursive https://github.com/andresgongora/synth-shell.git && \
    cd synth-shell && \
    git apply /opt/include/synth-shell-autoinstall.patch && \
    ./setup.sh && \
    cd .. && \
    rm -rf synth-shell

# Create scripts
RUN mkdir /opt/scripts && \
    chown -R $USER:$USER /opt/scripts && \
    cp /opt/include/scripts/* /opt/scripts && \
    rm -rf /opt/include/

RUN ln -s /opt/scripts/bmake.sh          /usr/bin/bmake && \
    ln -s /opt/scripts/check-connect.sh  /usr/bin/check-connect && \
    ln -s /opt/scripts/cleanup.sh        /usr/bin/cleanup && \
    ln -s /opt/scripts/del-docker.sh     /usr/bin/del-docker && \
    ln -s /opt/scripts/grefresh.sh       /usr/bin/grefresh && \
    ln -s /opt/scripts/string-replace.sh /usr/bin/string-replace && \
    ln -s /opt/scripts/search-pptx.sh    /usr/bin/search-pptx 

RUN cp -r /root/.bashrc /home/dev/ && \
    cp -r /root/.fonts /home/dev/ && \
    cp -r /root/.config /home/dev/ && \
    chown -R dev:dev /home/dev/
    
# Cleanup
RUN apt autoremove -y && \
    apt autoclean -y 

WORKDIR /home/dev
USER dev

# Install cargo
RUN curl https://sh.rustup.rs -sSf > cargo-installer.sh && \
    chmod +x cargo-installer.sh && \
    ./cargo-installer.sh -y && \
    rm cargo-installer.sh

# If you want to have the user have a password you can uncomment this 
# RUN echo "dev:dev" | chpasswd 

CMD ["/bin/bash"]
