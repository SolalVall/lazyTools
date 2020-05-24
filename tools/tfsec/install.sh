#!/bin/bash
###
# GENERIC VARS FOR TERRFORM
###
TFSEC_VERSION="0.19.0"
TFSEC_PACKAGE_URL="https://github.com/liamg/tfsec/releases/download/v${TFSEC_VERSION}/tfsec-linux-amd64"
TFSEC_SAVE_LOCATION="/usr/local/bin/tfsec"

###
# INSTALL TFSEC
##
# Retrieve bin and save it somewhere in $PATH
wget $TFSEC_PACKAGE_URL -O $TFSEC_SAVE_LOCATION

# Set correct permissions
chmod 755 $TFSEC_SAVE_LOCATION
