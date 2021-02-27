#!/bin/bash

# nomadic toolkit - A very good starting point for any IoT project.
# - command line.
# - simple: 
# - flexible: usage can be taylored to need.
# - functional: can all be used for many, many things.
#
NTK=(vim emacs-nox ruby-full figlet lolcat git wget curl redis-server redis-tools mosquitto mosquitto-clients htop aircrack-ng airgraph-ng nmap netcat tshark inotify-tools ax25-tools ax25-apps multimon-ng soundmodem espeak-ng)

rgb='lolcat -a -d 3 -p 5 -F 5'

if [ "$1" == "logo" ]; then
    cat logo.txt
elif [ "$1" == "install" ]; then
    # update and upgrand everything
    sudo apt-get update | $rgb
    sudo apt-get -y upgrade | $rgb
    # install standard tool kit
    sudo apt-get -y install $NTK | $rgb
    #
    # get nomadic gem
    #                    v--- source  v--- dev  v--- codename 
    git clone https://github.com/xorgnak/urban-invention | $rgb
    cd urban-invention
    # build gem locally ( for archetecture independance. )
    ./build.sh | $rgb
    # install executable
    sudo cp -vv nomadic /usr/bin/nomadic | $rgb
fi
# display branding
figlet -cf shadow "NOMADIC" | $rgb
figlet -cf mini "agile IoT linux" | $rgb
figlet -cf mini "(c) 2021" | $rgb
# run
nomadic

