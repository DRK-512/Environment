# Environment
This repository simply sets up my development environment for Ubuntu 20.04,22.04,24.04<br>
I setup VMs so often, it has gotten to the point where I am tired of re-running the same commands<br>
This will consist of the tools I use daily:
- Terminal preference
- .bashrc additions
- Neovim configuration
- Apt packages I utilize
- etc.

For testing purposes I have provided a Dockerfile, but it will not bring in the gnome theme since the container will not have a UI, but it will allow the user to have a feel for the shell I utilize and nvim configuration.

# Deployment on Linux
If you are on a linux distrobution that utilizes the apt package manager (AKA a debian based distrobution such as Ubuntu)<br>
All you need to do is just run the setup.sh script, and once the configuration is done, the device will reboot<br>
NOTE: I only utilize Debian distrobutions, so if you are on arch, you may need to sed all apt commands with pacman in the setup.sh script<br>
- The command would most likely look like this:
```bash
sed -i "s/apt up/pacman up/g" ./setup.sh
sed -i "s/apt inst/pacman inst/g" ./setup.s h
```
That has not been tested, and I do not plan on testing it unless I cave in and get arch linux

# Deployment on Windows
If you are unfortunate enough to utilize Windows > Linux, I want to first apologize to you for utiling such a bloated operating system that is not meant for software development in any regard.<br>
I then want to inform you that I have included a Dockerfile that will generate an Ubuntu 22.04 container so you can try out this setup, but will not have the gnome-theme I utilize<br>
