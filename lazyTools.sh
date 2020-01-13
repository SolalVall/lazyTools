#!/bin/bash

# GENERIC VARS
LT_VERSION="0.0.1"
PACKAGE_MANAGER=""
PACKAGE_NAME=""
PACKAGE_LIST=("git" "vagrant" "virtualbox")
DISPLAY_HELP="$(basename "$0") [-h|--help] [-l|--list] [-i|--install] [-v|--version]

Description: 

	lt (lazyTools) allows you to automatically install some packages by using your package
	manager or via some extra-steps and configuration

Options:
	
	[-h|--help] Display the following message 
	[-l|--list] List all available packages
	[-i|--install] Install a specific package
	[-v|--version] Display current version of the script

Examples:
	
	lt --install package
"

#GENERIC FUNCS
verify_package() {
	PACKAGE_NAME=$1

	#Verify if package is already or not (Depends of which command results status)
	IS_PACKAGE_INSTALLED=$(which $PACKAGE_NAME)
	if [ $? -ne 0 ]; then
		echo "$PACKAGE_NAME not installed"
		if [[ "$2" = "default_install" ]]; then
			echo "Start installation via $PACKAGE_MANAGER ..."
			install_package $PACKAGE_NAME
		fi
	else
		echo "$PACKAGE_NAME already installed"
	fi
}

install_package() {
	sudo $PACKAGE_MANAGER update
	sudo $PACKAGE_MANAGER install $1 -y
	echo "Package $1 installed"
}


verify_distrib() { 
	## Set user distrib
	echo "Verify Linux OS Distribution (Script only compatible with Debian or Redhat)"
	if [ -f /etc/lsb-release ]; then
		echo "Debian detected"
		PACKAGE_MANAGER="apt"	
	else
		echo "Can't resolve OS distribution"
		exit 1
	fi
}

## All options configuration 
case $1 in 
	-l|--list)
		echo -e "Packages available:\n"

		for package in ${PACKAGE_LIST[@]}; do
			echo -e "\t$package"
		done
	
		echo -e "\nIf you want to install a package please run the following lt command:" 
		echo -e "\n\tlt --install package_name\n"
		exit 0 
		;;

	-h|--help)
		echo "$DISPLAY_HELP"
		exit 0
		;;	

	-v|--version)
		echo "v$LT_VERSION"
		exit 0
		;;	

	-i|--install)
		if [ -z $2 ]; then
			echo "Please provide a package to install."
			echo "Too see the list of available package please run: lt -l"
			exit 1
		else
			verify_distrib

			if [[ " ${PACKAGE_LIST[@]} " =~ " $2 " ]]; then
				verify_package $2
			else
				echo "Package $2 doesn't not exists, please provide a valid package"
				echo "Too see the list of available package please run: lt -l"
				exit 1
			fi
		fi	
		exit 0
		;;	
esac
