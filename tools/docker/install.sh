#!/bin/bash
PACKAGE_MANAGER=$1
PACKAGE_NAME=$2

###
# Unistall old version (it preserves /var/lib/docker)
###
$PACKAGE_MANAGER remove docker docker-engine docker.io containerd rund -y

###
# Pre-Install requirements for docker
##
$PACKAGE_MANAGER update > /dev/null

# Install necessaries package
$PACKAGE_MANAGER install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y

# Add docker GPG keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Add docker repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

###
# Install Docker
###
# Re update because of the new docker repository
$PACKAGE_MANAGER update > /dev/null

# Install docker packages
$PACKAGE_MANAGER install docker-ce docker-ce-cli containerd.io -y
