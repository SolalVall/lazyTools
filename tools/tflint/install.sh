#!/bin/bash
###
# GENERIC VARS FOR TERRFORM
###
PACKAGE_MANAGER=$1
TFLINT_PACKAGE_URL="https://api.github.com/repos/terraform-linters/tflint/releases/latest"
TFLINT_SAVE_LOCATION="/tmp/tflint.zip"

###
# INSTALL TFLINT
##
# Retrieve zip and save it to /tmp
curl -L "$(curl -Ls $TFLINT_PACKAGE_URL | grep -o -E "https://.+?_linux_amd64.zip")" -o $TFLINT_SAVE_LOCATION

# Some very lightweigth disto doesn't have unzip cmd
$PACKAGE_MANAGER install unzip -y

# Unizp to $PATH
unzip $TFLINT_SAVE_LOCATION -d /usr/local/bin

# Clean
rm -f $TFLINT_SAVE_LOCATION
