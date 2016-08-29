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

if [[ "$1" == "--update" ]]
then
    if [ $(id -u) -ne 0 ]; then
      echo -e "$TXTERROR This script must be run as root." >&2
      exit 1
    fi
fi

echo -e "$TXTINFO Running md380easy as $USER"

if [[ "$1" == "--fw" ]]
then
  git clone https://github.com/travisgoodspeed/md380tools.git
  cd md380tools
  make clean

  ##### turn on radio in DFU mode to begin firmware update with USB cable ######
  echo "Now turn on the radio in DFU mode (holdig the PTT and the upper button) and plug in the programming cable"
  read -p "Press [Enter] key to start flashing..."
  make all flash

  ##### turn radio normally on to begin database loading with USB cable #####
  echo "Now turn on the radio in normally (don't unplug the programming cable!)"
  read -p "Press [Enter] key to start flashing..."
  sudo make flashdb
  echo "All done. you can now unplug the programming cable."
  cd ~
  rm -rf ./md380tools
fi
