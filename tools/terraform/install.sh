#!/bin/bash
###
# GENERIC VARS FOR TERRFORM
###
PACKAGE_MANAGER=$1
TERRAFORM_VERSION="0.12.24"
TERRAFORM_PACKAGE_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
TERRAFORM_SAVE_LOCATION="/tmp/terraform.zip"

###
# INSTALL TERRAFORM
##
# Retrieve zip and save it to /tmp
wget $TERRAFORM_PACKAGE_URL -O $TERRAFORM_SAVE_LOCATION

# Some very lightweigth disto doesn't have unzip cmd
$PACKAGE_MANAGER install unzip -y

# Unizp to $PATH
unzip $TERRAFORM_SAVE_LOCATION -d /usr/local/bin

# Clean
rm -f $TERRAFORM_SAVE_LOCATION
