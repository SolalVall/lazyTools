#!/bin/bash

# GENERIC VARS
## Global config
LT_VERSION="0.0.2"
LT_USER_HOME_LOCATION="$HOME/.lazyTools.d"
LT_BASE_LOCATION="/usr/local/bin/tools"
PACKAGE_MANAGER=""
PACKAGE_NAME=""
PACKAGE_DEFAULT_LIST=$(find $LT_BASE_LOCATION -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
PACKAGE_USER_LIST=$(find $LT_USER_HOME_LOCATION -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
PACKAGE_COMPLETE_LIST=("${PACKAGE_DEFAULT_LIST[@]}" "${PACKAGE_USER_LIST[@]}")
## Color settings
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
END="\e[0m"
## Help message
DISPLAY_HELP="${BOLD}> Usage: lt [-h|--help] [-l|--list] [-i|--install] [-v|--version]${END}

${BOLD}> Description:${END} 

	lt (lazyTools) allows you to automatically install some packages by using your package
	manager or via some extra-steps and configuration

${BOLD}> Options:${END}
	
	[-h|--help] Display the following message 
	[-v|--version] Display current version of the script
	[-l|--list] List all available packages
	[-i|--install] Install a specific package

${BOLD}> Examples:${END}
	
	lt --install package
"

# GENERIC FUNCS
verify_package() {
	PACKAGE_NAME=$1

	#Verify if package is already installed or not (Depends of which command results status)
	IS_PACKAGE_INSTALLED=$(which $PACKAGE_NAME)
	echo -e $BOLD"\n> Verify if package is already installed..."$END
	if [ $? -ne 0 ]; then
		echo -e $GREEN"Package $PACKAGE_NAME not installed"$END
		echo -e $BOLD"\n> Start package installation..."$END
		install_package
	else
		echo -e $YELLOW"Package $PACKAGE_NAME already installed"$END
		exit 
	fi
}

install_package() {
	# Verify if script folder for the package exists
	if [[ -d $LT_USER_HOME_LOCATION/$PACKAGE_NAME ]]; then
		# Verify if there is some script available
		if [[ -z $(ls $LT_USER_HOME_LOCATION/$PACKAGE_NAME) ]]; then
			echo -e $RED"No script(s) available"$END
			echo -e "Please create the necessaries script. For more information see the documentation"
			exit 1
		else
			#Verify that scripts in package dir are executables
			for script in $LT_USER_HOME_LOCATION/$PACKAGE_NAME/*; do
				if [[ $(stat -c "%a" "$script") -ne "755" ]]; then
					chmod 755 $script
				fi
			done
		fi
	else
		echo -e $RED"The curtom directory named: $LT_USER_HOME_LOCATION/$PACKAGE_NAME doesn't exists"$END
		echo -e "Please create the folder and its necessaries script. For more information see the documentation"
		exit 1
	fi

	# Execute default install script for the package
	$LT_USER_HOME_LOCATION/$PACKAGE_NAME/install.sh $PACKAGE_MANAGER $PACKAGE_NAME
	echo -e $GREEN"Package $1 installed"$END
}

verify_distrib() { 
	## Set user distrib
	echo -e $BOLD"> Verify OS Distribution..."$END
	if [ -f /etc/lsb-release ]; then
		echo -e $GREEN"Debian detected\n"$END
		PACKAGE_MANAGER="apt"	
	else
		echo -e $RED"Can't resolve OS distribution\n"$END
		exit 1
	fi
}

## All options configuration 
case $1 in 
	-l|--list)
		echo -e $BOLD"> Packages available:\n"$END

		echo -e "${PACKAGE_COMPLETE_LIST[@]}" | tr ' ' '\n' | sort -u | grep -v ".git"
	
		echo -e $BOLD"\n> Installation:"$END
		echo -e "\n  lt [-i|--install] package_name\n"
		exit 0 
		;;

	""|-h|--help)
		echo -e "$DISPLAY_HELP"
		exit 0
		;;	

	-v|--version)
		echo -e $BOLD"> lazyTools v$LT_VERSION"$END
		exit 0
		;;	

	-i|--install)
		if [ -z $2 ]; then
			echo -e $RED"Please provide a package to install !"$END
			echo -e "Install a package          | lt -i my_package"
			echo -e "Check available packages   | lt -l"
			exit 1
		else
			verify_distrib

			echo -e $BOLD"> Verify if package exists..."$END
			if [[ " ${PACKAGE_LIST[@]} " =~ " $2 " ]]; then
				echo -e $GREEN"Package $2 available"$END
				verify_package $2
			else
				echo -e $YELLOW"Package $2 doesn't not exists, please provide a valid package"$END
				echo -e "Too see the list of available package please run: lt -l\n"
				exit 1
			fi
		fi	
		exit 0
		;;	
	*)
		echo -e $RED"$1 is not a valid option"$END
		echo -e "Get help by running: lt [-h|--help]"
		exit 1
		;;
esac
