#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2
$PACKAGE_MANAGER update > /dev/null

# WORKS FOR UBUNTU 20.04 and below (new method for ubuntu 20.10)

###
# Polybar install all required packages
###
$PACKAGE_MANAGER install cmake cmake-data libcairo2-dev libxcb1-dev libxcb-ewmh-dev libxcb-icccm4-dev libxcb-image0-dev libxcb-randr0-dev libxcb-util0-dev libxcb-xkb-dev pkg-config python3-xcbgen xcb-proto libxcb-xrm-dev i3-wm libasound2-dev libmpdclient-dev libiw-dev libcurl4-openssl-dev libpulse-dev libxcb-composite0-dev xcb libxcb-ewmh2 -y

###
# Install polybar from github from github
###
git clone https://github.com/jaagr/polybar.git

# Build
cd polybar
yes | ./build.sh

# Create config file
cd build
make userconfig

# Clean
cd ../..
rm -rf $PWD/polybar
