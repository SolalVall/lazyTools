#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2

###
# Pre-install
###
$PACKAGE_MANAGER update > /dev/null

# Install necesasry package
$PACKAGE_MANAGER install software-properties-common -y

# Add ansible repository
apt-add-repository --yes --update ppa:ansible/ansible

###
# Install
###
$PACKAGE_MANAGER install $PACKAGE_NAME -y
