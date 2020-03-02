#!/bin/bash

#variables
BASE_LOCATION="/usr/local/bin"
LAZYTOOLS_LOCATION="$BASE_LOCATION/lazyTools"
LAZYTOOLS_PACKAGES_LOCATION="$LAZYTOOLS_LOCATION/tools"
LAZYTOOLS_TEMPLATES_LOCATION="$LAZYTOOLS_LOCATION/templates"
LAZYTOOLS_EXE="$LAZYTOOLS_LOCATION/lazyTools.sh"

#funcs
verify_status() {
	if [[ $? -eq 0 ]]; then
		echo -e "\e[1;32mDone\e[0m"
	else
		echo -e "\e[1;31m${@}\e[0m"
		exit 1
	fi
}

#Main
if [ ! -z $(which $LAZYTOOLS_EXE) ]; then
	echo -e "\e[33mLazy tools ($LAZYTOOLS_EXE) already installed\e[0m"
	$LAZYTOOLS_EXE --version
	exit 0
else
	echo -e "Create lazyTools location"
	CREATE_LOCATION_CMD=$(mkdir $LAZYTOOLS_LOCATION)
	verify_status $CREATE_LOCATION_CMD

	echo -e "Export lazyTools to new location"
	COPY_TOOL_CMD=$(cp -R $PWD/{tools,templates,lazyTools.sh} $LAZYTOOLS_LOCATION 2>&1 >/dev/null)
	verify_status $COPY_TOOL_CMD

	echo -e "Setup lt (lazyTools) as executable"
	CONF_CMD=$(ln -s $LAZYTOOLS_EXE $BASE_LOCATION/lt 2>&1 >/dev/null)
	verify_status $CONF_CMD

	echo -e "Create custom lazytools folder for user"
	# We don't want to override the lazyTools user folder + we want to create it with username who executed the sudo cmd
	CUSTOM_CMD=$(sudo -Hu $SUDO_USER sh -c "mkdir -p $HOME/.lazyTools.d")
	verify_status $CUSTOM_CMD

	echo -e "\e[1;32m\nIntallation Complete\e[0m"
	$LAZYTOOLS_EXE --version
fi	
