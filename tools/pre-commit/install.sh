#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2

###
# pre-commit required pip
###
$PACKAGE_MANAGER update > /dev/null
$PACKAGE_MANAGER install python3-pip -y

###
# Install pre-commit via pip
###
# Follow installation from https://pre-commit.com/#installation
pip3 install pre-commit
