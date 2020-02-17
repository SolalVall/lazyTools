#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2
sudo $PACKAGE_MANAGER update > /dev/null
sudo $PACKAGE_MANAGER install virtualbox -y > /dev/null
sudo $PACKAGE_MANAGER install $PACKAGE_NAME -y > /dev/null
