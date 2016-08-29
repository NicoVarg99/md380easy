#!/bin/bash


export RED='\033[1;91m'
export GREEN='\033[1;92m'
export BLUE='\033[1;94m'
export RESETCOLOR='\033[1;00m'
export TXTINFO="$GREEN[INFO]$RESETCOLOR"
export TXTERROR="$RED[ERROR]$RESETCOLOR"
export TXTQST="$BLUE[QUESTION]$RESETCOLOR"

if [ $(id -u) -eq 0 ]; then
    sudo bash /usr/sbin/md380 $1
    exit 0
fi


if [[ "$1" == "--uninstall" ]]
then
    if [ $(id -u) -ne 0 ]; then
      echo -e "$TXTERROR This script must be run as root." >&2
      exit 1
    fi
fi

echo -e "$TXTINFO Running md380easy as $USER"
