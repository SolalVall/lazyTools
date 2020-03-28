#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2
$PACKAGE_MANAGER update > /dev/null

###
# i3 install all required packages
###
$PACKAGE_MANAGER install libxcb-shape0-dev libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev autoconf xutils-dev libtool automake git -y

###
# Specific install for libxcb-xrm-dev (fixed for ubuntu 16)
###
# Fetch project 
git clone https://github.com/Airblader/xcb-util-xrm && cd xcb-util-xrm
git submodule update --init

# Build the lib
./autogen.sh --prefix=/usr
make
sudo make install

# Clean
cd $(dirname $PWD)
rm -rf $PWD/xcb-util-xrm

###
# Install i3-gaps from github
###
# Fetch i3-gaps project
git clone https://www.github.com/Airblader/i3 && cd i3 
git checkout gaps && git pull

# Build
autoreconf --force --install
## Need to recreate build folder
rm -rf build
mkdir build && cd build
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

# Clean
cd ..
cd $(dirname $PWD)
rm -rf $PWD/i3

###
# i3 necessaries tools
###
$PACKAGE_MANAGER install dmenu i3status -y 

###
# INFO MESSAGE
###
echo -e "\033[32m============ INSTALLATION COMPLETE ===========\033[0m"
echo -e "\033[32mPlease logout and choose i3 on your login page\033[0m"
echo -e "\033[32m==============================================\033[0m"
