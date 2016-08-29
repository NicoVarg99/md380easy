#!/bin/bash

export RED='\033[1;91m'
export GREEN='\033[1;92m'
export BLUE='\033[1;94m'
export RESETCOLOR='\033[1;00m'
export TXTINFO="$GREEN[INFO]$RESETCOLOR"
export TXTERROR="$RED[ERROR]$RESETCOLOR"
export TXTQST="$BLUE[QUESTION]$RESETCOLOR"

function fnuninstall {
	rm -rf ~/md380tools
	rm /etc/udev/rules.d/99-md380.rules
	echo -e "$TXTINFO md380 uninstalled"
	rm /usr/bin/md380
	rm /usr/sbin/md380
}


if [ $(id -u) -ne 0 ]; then
  if [ -f /usr/bin/md380 ]; then
    bash /usr/bin/md380
    exit 0
  else
	  echo "[ERROR] This script must be run as root." >&2 
	  exit 1
	fi
fi

echo md380easy-root

if [[ "$1" == "--uninstall" ]]
then
        echo -e "$TXTINFO will now uninstall md380easy"
	fnuninstall
fi
