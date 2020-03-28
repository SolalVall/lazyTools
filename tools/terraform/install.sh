#!/bin/bash
###
# GENERIC VARS FOR TERRFORM
###
TERRAFORM_VERSION="0.12.24"
TERRAFORM_PACKAGE_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
TERRAFORM_SAVE_LOCATION="/tmp/terraform.zip"

###
# INSTALL TERRAFORM
##
# Retrieve zip and save it to /tmp
wget $TERRAFORM_PACKAGE_URL -O $TERRAFORM_SAVE_LOCATION

# Unizp to $PATH
unzip $TERRAFORM_SAVE_LOCATION -d /usr/local/bin

# Clean
rm -f $TERRAFORM_SAVE_LOCATION
