#!/bin/bash

# GENERIC VARS
## Global config
LT_VERSION="0.1"
LT_USER_HOME_LOCATION="$HOME/.lazyTools.d"
LT_BASE_TOOLS_LOCATION="/usr/local/bin/tools"
LT_BASE_TEMPLATE_LOCATION="/usr/local/bin/templates"
PACKAGE_MANAGER=""
PACKAGE_NAME=""

## Retrieve all availble packages
PACKAGE_DEFAULT_LIST=$(find $LT_BASE_TOOLS_LOCATION -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
PACKAGE_USER_LIST=$(find $LT_USER_HOME_LOCATION -mindepth 1 -maxdepth 1 -type d -exec basename {} \;)
PACKAGE_FULL_LIST=("${PACKAGE_DEFAULT_LIST[@]}" "${PACKAGE_USER_LIST[@]}")
### Get all packages whitout duplicated from home and base base folder
PACKAGE_LIST=$(echo "${PACKAGE_FULL_LIST[@]}" | tr ' ' '\n' | sort -u | grep -v ".git")
### Get only package duplicated between home and base
PACKAGE_LIST_DUPLICATE=$(echo "${PACKAGE_FULL_LIST[@]}" |tr ' ' '\n' | sort | grep -v ".git" | uniq -d) 

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
	[-c|--create] Create your own lazytools package

${BOLD}> Examples:${END}
	
	lt --install package
"

# GENERIC FUNCS
verify_package() {
	PACKAGE_NAME=$1
	#Verify if package is already installed or not (Depends of which command results status)
	echo -e $BOLD"\n> Verify if package is already installed..."$END
	IS_PACKAGE_INSTALLED=$(which $PACKAGE_NAME)
	if [ $? -ne 0 ]; then
		echo -e $GREEN"Package $PACKAGE_NAME not installed"$END
		echo -e $BOLD"\n> Start package installation..."$END
		install_package
	else
		echo -e $YELLOW"Package $PACKAGE_NAME already installed"$END
		exit 
	fi
}

execute_script() {
	SCRIPT_TYPE=$1
	SCRIPT_LOCATION=$2
	if [[ $SCRIPT_LOCATION == $LT_USER_HOME_LOCATION ]]; then
		# Proceed some verification
		echo "Verify $SCRIPT_TYPE.sh script permissions..."
		#Verify that scripts in package dir are executables
		if [[ $(stat -c "%a" "$LT_USER_HOME_LOCATION/$PACKAGE_NAME/$SCRIPT_TYPE.sh") -ne "755" ]]; then
			chmod 755 $LT_USER_HOME_LOCATION/$PACKAGE_NAME/$SCRIPT_TYPE.sh 
		fi
	fi

	echo "Execute your custom $PACKAGE_NAME $SCRIPT_TYPE script..."
	$SCRIPT_LOCATION/$PACKAGE_NAME/$SCRIPT_TYPE.sh $PACKAGE_MANAGER $PACKAGE_NAME
}

install_package() {
	# First during an installation we always start by executing the install script
	# from the custom lazytools home folder if the script exsists then if not from the main bin folder
	if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/install.sh ]]; then
		echo "Homemade LazyTools package detected.."
		execute_script install $LT_USER_HOME_LOCATION 

		if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/config.sh ]]; then
			echo "A custom config script detected for $PACKAGE_NAME" 
			echo "Start installation of custom scripts"
			execute_script config $LT_USER_HOME_LOCATION 
		else
			echo "No custom config script detected for $PACKAGE_NAME"
		fi
		exit 0 
	else
		echo "Install default LazyTools package.."
		execute_script install $LT_BASE_TOOLS_LOCATION 
		
		if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/config.sh ]]; then
			echo "A custom config script has been detected for $PACKAGE_NAME" 
			execute_script config $LT_USER_HOME_LOCATION 
		else
			echo "No custom config script detected for $PACKAGE_NAME"
		fi
		exit 0 
	fi	

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

create_package() {
	echo -e "[OK] Create LazyTools package location in $LT_USER_HOME_LOCATION"
	mkdir $LT_USER_HOME_LOCATION/$1		
	echo -e "[OK] Copy default install template script in $LT_USER_HOME_LOCATION/$1"
	cp $LT_BASE_TEMPLATE_LOCATION/install_template.sh $LT_USER_HOME_LOCATION/$1/install.sh
}

## All options configuration 
case $1 in 
	-l|--list)
		echo -e $BOLD"> Packages available:\n"$END

		echo -e "${PACKAGE_LIST[@]}" | sed 's/^/  /g'
	
		echo -e $BOLD"\n> Installation:"$END
		echo -e "\n  lt [-i|--install] package_name\n"
		exit 0 
		;;

	# Print help when user don't provide argument
	""|-h|--help)
		echo -e "$DISPLAY_HELP"
		exit 0
		;;	

	-v|--version)
		echo -e $BOLD"> lazyTools v$LT_VERSION"$END
		exit 0
		;;	

	-c|--create)
		if [ -z $2 ]; then
			echo -e $RED"Please provide a package to create !"$END
			echo -e "Maybe you want to run: lt -c my_package"
			exit 1
		else
			echo -e $BOLD"> Verify if LazyTools package already exists..."$END
			if [[ $PACKAGE_LIST =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
				echo -e $YELLOW"LazyTools package name $2 already exists"$END
				exit 1
			else
				echo -e $GREEN"LazyTools package name $2 not exists\n"$END
				echo -e $BOLD"> Create LaztTools package named $2 in $LT_USER_HOME_LOCATION ..."$END
				create_package $2	
				echo -e $GREEN"LazyTools package named $2 sucessfully created in $LT_USER_HOME_LOCATION/$2 \n"$END
				exit 0
			fi
		fi
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
			#[[:space:]] is a bash convention (in fact item in list are separated by space not coma in bash) 
			if [[ $PACKAGE_LIST =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
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
