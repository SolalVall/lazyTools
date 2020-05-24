#!/bin/bash
###
# GENERIC VARS FOR TERRFORM
###
TERRAGRUNT_VERSION="0.23.20"
TERRAGRUNT_PACKAGE_URL="https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64"
TERRAGRUNT_SAVE_LOCATION="/usr/local/bin/terragrunt"

###
# INSTALL TERRAGRUNT
##
# Retrieve bin and save it somewhere in $PATH
wget $TERRAGRUNT_PACKAGE_URL -O $TERRAGRUNT_SAVE_LOCATION

# Set correct permissions
chmod 755 $TERRAGRUNT_SAVE_LOCATION
