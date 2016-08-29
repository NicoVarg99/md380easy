#!/bin/bash

if [ $(id -u) -eq 0 ]; then
    sudo bash /usr/sbin/md380 $1
    exit 0
fi





echo md380easy-user

if [[ "$1" == "--uninstall" ]]
then
    if [ $(id -u) -ne 0 ]; then
	    echo -e "$TXTERROR This script must be run as root." >&2
	    exit 1
    fi
fi
