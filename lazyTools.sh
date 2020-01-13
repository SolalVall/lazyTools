#!/bin/sh

# GENERIC VARS
LT_VERSION="0.0.1"
PACKAGE_MANAGER=""
PACKAGE_NAME=""

#GENERIC FUNCS
verify_package() {
	#Remove -- from user input
	PACKAGE_NAME=${1#--}

	#Verify if package is already or not (Depends of which command results status)
	IS_PACKAGE_INSTALLED=$(which $PACKAGE_NAME)
	if [ $? -ne 0 ]; then
		echo "$PACKAGE_NAME not installed"
		if [ "$2" = "default_install" ]; then
			echo "Start installation via $PACKAGE_MANAGER ..."
			install_package $PACKAGE_NAME
		fi
	else
		echo "$PACKAGE_NAME already installed"
		break
	fi
}

install_package() {
	sudo $PACKAGE_MANAGER update
	sudo $PACKAGE_MANAGER install $1 -y
	echo "Package $PACKAGE_NAME installed"
}

## In case user want to know the version of the script
if [ $1 = "--version" ]; then 
	echo "v$LT_VERSION"
	exit 0
fi
 
## Set user distrib
echo "Verify Linux OS Distribution (Script only compatible with Debian or Redhat)"

if [ -f /etc/lsb-release ]; then
	echo "Debian detetcted"
	PACKAGE_MANAGER="apt"	
fi

## All options available to user
case $1 in 
	--git)
	verify_package $1 default_install
	;;
	--vagrant)
	echo "Vagrant required virtualbox in order to work"
	verify_package --virtualbox default_install
	verify_package $1 default_install
	;;
	--virtualbox)
	verify_package $1 default_install
	;;
esac
