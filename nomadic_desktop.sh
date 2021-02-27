#!/usr/bin/bash

##
# install basic window manager, browser, and terminal.
sudo apt install -y lxde firefox-esr terminator

##
#
f=.config/autostart/browser.desktop
echo "[Desktop Entry]" > $f
echo "Type=Application" >> $f 
echo "Exec=x-www-browser --kiosk https://vango.me" >> $f

##
# autostart administrative terminal
f=.config/autostart/terminal.desktop
echo "[Desktop Entry]" > $f
echo "Type=Application" >> $f
echo "Exec=x-terminal-emulator --fullscreen -e screen" >> $f

##
# configure terminal multiplexer to runb in terminal with organizer and communicator.
echo "startup_message off" > ~/.screenrc
echo "term screen-256color" >> ~/.screenrc
echo "nonblock on" >> ~/.screenrc
echo "vbell off" >> ~/.screenrc
echo "screen -t '>' 0 emacs -nw --funcall erc --visit ~/index.org" >> ~/.screenrc
echo "hardstatus alwayslastline" >> ~/.screenrc
echo "hardstatus string '%w'" >> ~/.screenrc
echo "updated ~/.screenrc"
##
# start window manager
echo "exec lxsession" > ~/.xinitrc
echo "updated ~/.xinitrc"
