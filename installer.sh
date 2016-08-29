#!/bin/bash

export RED='\033[1;91m'
export GREEN='\033[1;92m'
export BLUE='\033[1;94m'
export RESETCOLOR='\033[1;00m'
export TXTINFO="$GREEN[INFO]$RESETCOLOR"
export TXTERROR="$RED[ERROR]$RESETCOLOR"
export TXTQST="$BLUE[QUESTION]$RESETCOLOR"

#Check that we are root before installing
function fnchkroot {
	if [ $(id -u) -ne 0 ]; then
		echo -e "$TXTERROR This script must be run as root." >&2
		exit 1
	fi
}

#Check if md380 is already installed (and ask to reinstall it)
function fnchkinstalled {
	INSTALLED="0"

	if [ -f /usr/bin/md380 ] ; then
	        INSTALLED="1"
	fi

	if [ -f /usr/sbin/md380 ] ; then
	        INSTALLED="1"
	fi

	if [[ "$INSTALLED" -eq "1" ]]
	then
		#installed
		echo -e "$TXTINFO md380 is already installed"
		echo -ne "$TXTQST "
		read -p "Would you like to reinstall it? (s/N) " -n 1 -r

		if [[ $REPLY != "" ]]
		then
			echo
		fi

		if [[ $REPLY =~ ^[YySs]$ ]]
		then
			echo -e "$TXTINFO md380 will be removed and reinstalled"
			fnuninstall
		else
			exit 0

		fi
	fi
}

#Install missing dependencies
function fnfixdep {
	sudo apt install cmake git python-pip gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi libusb-1.0 python-usb
	sudo pip install pyusb -U
	echo -e "$TXTINFO missing dependencies fixed"
}

function fninstall {
	echo -ne "$TXTQST "
	read -p "Install only for user \"root\"? (s/N) " -n 1 -r

	if [[ $REPLY != "" ]]
	then
		echo
	fi

	if [[ $REPLY =~ ^[YySs]$ ]]
	then
		echo -e "$TXTINFO users will NOT be able to run this script"
		fnfixdep
		wget https://raw.githubusercontent.com/NicoVarg99/md380easy/master/md380easy-root.sh
		mv md380easy-root.sh /usr/sbin/md380
		
		chmod +x /usr/sbin/md380
		
		git clone https://github.com/travisgoodspeed/md380tools.git
		cd md380tools		
	else
		echo -e "$TXTINFO users will be able to run this script"
		fnfixdep
		wget https://raw.githubusercontent.com/NicoVarg99/md380easy/master/md380easy-root.sh
		mv md380easy-root.sh /usr/sbin/md380
		wget https://raw.githubusercontent.com/NicoVarg99/md380easy/master/md380easy-user.sh
		mv md380easy-user.sh /usr/bin/md380

		chmod +x /usr/sbin/md380
		chmod +x /usr/bin/md380
		
		https://raw.githubusercontent.com/travisgoodspeed/md380tools/master/99-md380.rules
		mv 99-md380.rules /etc/udev/rules.d/ #makes md380 available for all users
	fi


	
	echo -e "$TXTINFO md380 installed"
}

function fnuninstall {
	rm -rf ~/md380tools
	rm /usr/bin/md380
	rm /usr/sbin/md380
	rm /etc/udev/rules.d/99-md380.rules
	echo -e "$TXTINFO md380 uninstalled"
}

cd ~

if [[ "$1" == "--uninstall" ]]
then
        echo -e "$TXTINFO will now uninstall md380easy"
	fnchkroot
	fnuninstall
else
        echo -e "$TXTINFO will now install md380easy"
	fnchkroot
	fnchkinstalled
	fninstall
fi

rm $0
