#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2
$PACKAGE_MANAGER update > /dev/null
$PACKAGE_MANAGER install virtualbox -y
$PACKAGE_MANAGER install $PACKAGE_NAME -y
