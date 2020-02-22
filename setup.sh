#!/bin/bash

#variables
LAZYTOOLS_PACKAGES_LOCATION="/usr/local/bin/tools"
LAZYTOOLS_TEMPLATES_LOCATION="/usr/local/bin/templates"
LAZYTOOLS_EXE="lt"

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
	echo -e "Export all lazyTools packages"
	COPY_TOOL_CMD=$(cp -R $PWD/tools $(dirname $LAZYTOOLS_PACKAGES_LOCATION) 2>&1  >/dev/null)
	verify_status $COPY_TOOL_CMD

	echo -e "Export all lazyTools templates"
	COPY_TEMPLATES_CMD=$(cp -R $PWD/templates $(dirname $LAZYTOOLS_TEMPLATES_LOCATION) 2>&1  >/dev/null)
	verify_status $COPY_TEMPLATES_CMD

	echo -e "Setup $LAZYTOOLS_EXE (lazyTools) as executable"
	CONF_CMD=$(cp $PWD/lazyTools.sh $(dirname $LAZYTOOLS_PACKAGES_LOCATION)/$LAZYTOOLS_EXE 2>&1 >/dev/null)
	verify_status $CONF_CMD

	echo -e "Create custom lazytools folder for user"
	# We don't want to override the lazyTools user folder
	CUSTOM_CMD=$(mkdir -p $HOME/.lazyTools.d)
	verify_status $CUSTOM_CMD

	echo -e "\e[1;32m\nIntallation Complete\e[0m"
	$LAZYTOOLS_EXE --version
fi	
