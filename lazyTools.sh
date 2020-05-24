#!/bin/bash

# GENERIC VARS
## Global config
LT_VERSION="0.4.2"
LT_USER_HOME_LOCATION="$HOME/.lazyTools.d"
LT_BASE_LOCATION="/usr/local/bin/lazyTools"
LT_BASE_TOOLS_LOCATION="$LT_BASE_LOCATION/tools"
LT_BASE_TEMPLATE_LOCATION="$LT_BASE_LOCATION/templates"
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
DISPLAY_HELP="${BOLD}> Usage: lt [-h|--help] [-l|--list] [-i|--install] [-e|--exec] [-c|--create] [-u|--update] [-v|--version]${END}

${BOLD}> Description:${END}

	lt (lazyTools) allows you to automatically install some packages by using your package
	manager or via some extra-steps and configuration

${BOLD}> Options:${END}

	[-h|--help] Display the following message
	[-v|--version] Display current version of the script
	[-l|--list] List all available packages
	[-i|--install] Install a specific package
	[-c|--create] Create your own lazytools package
	[-e|--exec] Execute user custom config script
	[-u|--update] Update Lazy Tools

${BOLD}> Examples:${END}

	lt --create package
	lt --install package
	lt --install package1 package2
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

	#if it's a default install script passed some vars, otherwise it's a custom user config we don't want to
	#constraint him with some useless vars
	if [[ "$SCRIPT_TYPE" == "install" ]]; then
		echo "Start installation of $SCRIPT_LOCATION/$PACKAGE_NAME/install.sh"
		$SCRIPT_LOCATION/$PACKAGE_NAME/$SCRIPT_TYPE.sh $PACKAGE_MANAGER $PACKAGE_NAME
	else
		echo "Start installation of $SCRIPT_LOCATION/$PACKAGE_NAME/config.sh"
		sudo -i -u $SUDO_USER $SCRIPT_LOCATION/$PACKAGE_NAME/$SCRIPT_TYPE.sh
	fi
}

install_package() {
	# First during an installation we always start by executing the install script
	# from the custom lazytools home folder if the script exsists then if not from the main bin folder
	echo -e $BOLD"\n>>> Verify if it's your own custom package..."$END
	if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/install.sh ]]; then
		echo -e $GREEN"Homemade LazyTools package detected"$END
		execute_script install $LT_USER_HOME_LOCATION

		echo -e $BOLD"\n>>> Verify if a custom config script exists..."$END
		if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/config.sh ]]; then
			echo -e $GREEN"Custom config script detected"$END
			execute_script config $LT_USER_HOME_LOCATION
		else
			echo "No custom config script detected for $PACKAGE_NAME"
		fi
	else
		echo -e "No custom install script detected for $PACKAGE_NAME"$END
		if [[ -f $LT_BASE_TOOLS_LOCATION/$PACKAGE_NAME/install.sh ]]; then
			echo "Install default LazyTools package.."
			execute_script install $LT_BASE_TOOLS_LOCATION
		fi

		echo -e $BOLD"\n>>> Verify if a custom config script exists..."$END
		if [[ -f $LT_USER_HOME_LOCATION/$PACKAGE_NAME/config.sh ]]; then
			echo -e $GREEN"Custom config script detected"$END
			execute_script config $LT_USER_HOME_LOCATION
		else
			echo "No custom config script detected for $PACKAGE_NAME"
		fi
	fi

	echo -e $GREEN"Installation of $PACKAGE_NAME done"$END
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
			if [[ $PACKAGE_USER_LIST =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
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

	-u|--update)
		LATEST_LT_VERSION=$(curl -sL "https://github.com/SolalVall/lazyTools/releases/latest" | grep -Po 'tree/v([0-9]|\.)+' | head -n1 | sed 's/^.*v//g')
		echo -e $BOLD"> Check if a new version of lazy tools is available"$END
		if [[ "$LT_VERSION" != "$LATEST_LT_VERSION" ]]; then
			echo -e $GREEN"New version of LazyTools available: v$LATEST_LT_VERSION\n"$END
			echo -e $BOLD"> Start installation of LazyTools v$LATEST_LT_VERSION"$END
			git clone https://github.com/SolalVall/lazyTools.git /tmp/lazyTools
			cp -R /tmp/lazyTools/{tools,templates,lazyTools.sh} $LT_BASE_LOCATION
			rm -rf /tmp/lazyTools
			echo -e $GREEN"LazyTools Updated !\n"$END
			lt --version
			exit 0
		else
			echo -e $GREEN"Your LazyTools is the latest version (v$LT_VERSION)\n"$END
			exit 0
		fi
		;;


	-e|--exec)
		if [ -z $2 ]; then
			echo -e $RED"Please provide a package to config !"$END
			echo -e "Run config for a package | lt -i my_package"
			exit 1
		else
			echo -e $BOLD"> Verify if package exists..."$END
			#[[:space:]] is a bash convention (in fact item in list are separated by space not coma in bash)
			if [[ $PACKAGE_LIST =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
				echo -e $GREEN"Package $2 available"$END

				echo -e $BOLD"\n> Verify if custom script exists..."$END
				if [[ -f $LT_USER_HOME_LOCATION/$2/config.sh ]]; then
					echo "A custom config script detected for $2"
					PACKAGE_NAME=$2
					execute_script config $LT_USER_HOME_LOCATION
					exit 0
				else
					echo -e $RED"No custom config script named config.sh detected in $LT_USER_HOME_LOCATION/$2"$EMD
					exit 1
				fi
			else
				echo -e $RED"Package $2 not found in your home lazyTools folder"$END
				exit 1
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
			echo -e "================== Verification ===================\n"
			verify_distrib

			#Handle case where user provide multiple packages
			if [[ "$#" -gt 2 ]]; then
				echo "===== Multiple packages installation detected ====="
				#Start to iterate from second argument pass by the user (we don't want -i|--install)
				for (( i=2; i<=$#; i++ ))
				do
					#${!i} bash convention for variable extension
					package="${!i}"

					#Some calculs to get a clean header/footer to print to user
					total_len=50
					package_string_len="${#package}"
					sub_string_len=$(($total_len - $package_string_len))
					start_string_len=$(($sub_string_len/2))
					if (($sub_string_len % 2 )); then
						start_string_len=$(($sub_string_len/2))
						end_string_len=$(($sub_string_len/2))
					else
						start_string_len=$(($sub_string_len/2))
						end_string_len=$(($sub_string_len/2 - 1))
					fi

					start_string=$(printf "%-${start_string_len}s" "-")
					end_string=$(printf "%-${end_string_len}s" "-")
					echo -e "\n${start_string// /-} $package ${end_string// /-}"

					echo -e $BOLD"> Verify if package exists..."$END
					#[[:space:]] is a bash convention (in fact item in list are separated by space not coma in bash)
					if [[ $PACKAGE_LIST =~ (^|[[:space:]])"${!i}"($|[[:space:]]) ]]; then
						echo -e $GREEN"Package ${!i} available"$END
						verify_package "${!i}"
					else
						echo -e $YELLOW"Package ${!i} doesn't not exists, please provide a valid package"$END
						echo -e "Too see the list of available package please run: lt -l\n"
						exit 1
					fi

					footer_string=$( printf "%-50s" "-" )
					echo -e "${footer_string// /-}\n"
				done
			else
				echo -e $BOLD"> Verify if package exists..."$END
				#[[:space:]] is a bash convention (in fact item in list are separated by space not coma in bash)
				if [[ $PACKAGE_LIST =~ (^|[[:space:]])$2($|[[:space:]]) ]]; then
					echo -e $GREEN"Package $2 available"$END
					verify_package $2
					exit 0
				else
					echo -e $YELLOW"Package $2 doesn't not exists, please provide a valid package"$END
					echo -e "Too see the list of available package please run: lt -l\n"
					exit 1
				fi
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
