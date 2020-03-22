#!/bin/bash

test_lt() {
	echo -e "\n\033[34m[TEST: CHECK MANPAGE]\033[0m\n"
	vagrant ssh -c "lt -h"
	echo -e "\n\033[34m[TEST: CHECK VERSION]\033[0m\n"
	vagrant ssh -c "lt -v"
	echo -e "\n\033[34m[TEST: CREATE PACKAGE NAMED FOO]\033[0m\n"
	vagrant ssh -c "lt -c foo"
	echo -e "\n\033[34m[TEST: LIST ALL PACKAGES]\033[0m\n"
	vagrant ssh -c "lt -l"
	echo -e "\n\033[34m[TEST: INSTALL ONE PACKAGE (GIT)]\033[0m\n"
	vagrant ssh -c "sudo lt -i git"
	echo -e "\n\033[34m[TEST: INSTALL MULTIPLES PACKAGES (vim, foo)]\033[0m\n"
	vagrant ssh -c "sudo lt -i vim foo"
}

is_vagrant_installed=$(which vagrant)
if [[ $? -ne 0 ]]; then
	echo -e "Virtualbox not install.. Please install it \n Run: [apt/yum] install virtualbox -y"
	exit 1
fi

is_vagrant_installed=$(which vagrant)
if [[ $? -ne 0 ]]; then
	echo -e "Vagrant not install.. Please install it \n Run: [apt/yum] install vagrant -y"
	exit 1
else
	if [[ -f "$PWD/Vagrantfile" ]]; then
		echo -e "\n\033[1m================ BUILD ENVIRONEMENT ================\033[0m\n"
		vagrant up 
		if [[ $? -ne 0 ]]; then
			echo -e "\033[31m \n>>>>>>>> ENVIRONMENT BUILD FAILED\033[0m"
			exit 1 
		else	
			echo -e "\033[32m \n>>>>>>>> ENVIRONMENT BUILD SUCCESS\033[0m\n"
			echo -e "\033[1m================ TEST ENVIRONEMENT ================\033[0m\n"
			test_lt
			echo -e "\033[32m \n>>>>>>>> ALL LAZYTOOLS TESTS SUCCEED\033[0m\n"
			echo -e "\n\033[1m================ CLEAN ENVIRONEMENT ================\033[0m\n"
                        vagrant destroy -f
			echo -e "\n\033[32m \n>>>>>>>> ENVIRONNEMNT DESTROY SUCCESS\033[0m\n"
			exit 0
		fi
	else
		echo "Please create a Vagrantfile"
		exit 1
	fi
fi
