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


if [[ "$1" == "--all" ]]
then
  git clone https://github.com/travisgoodspeed/md380tools.git
  cd md380tools
  make clean

  ##### turn on radio in DFU mode to begin firmware update with USB cable ######
  echo -e "$TXTINFO Tturn on the radio in DFU mode (holdig the PTT and the upper button) and plug in the programming cable."
  read -p "Press [Enter] key to start flashing..."
  make all flash
  echo -e "$TXTINFO Firmware flashed."
  
  ##### turn radio normally on to begin database loading with USB cable #####
  echo -e "$TXTINFO Now turn on the radio in normally (don't unplug the programming cable!)"
  read -p "Once done, press [Enter] key to start flashing..."
  make flashdb
  echo -e "$TXTINFO UsersCSV flashed."
  
  echo -e "$TXTINFO All done. you can now unplug the programming cable."
  cd ~
  rm -rf ./md380tools
  
  exit 0
fi

if [[ "$1" == "--fw" ]]
then
  git clone https://github.com/travisgoodspeed/md380tools.git
  cd md380tools
  make clean

  ##### turn on radio in DFU mode to begin firmware update with USB cable ######
  echo -e "$TXTINFO Turn on the radio in DFU mode (holdig the PTT and the upper button) and plug in the programming cable."
  read -p "Press [Enter] key to start flashing..."
  make all flash
  echo -e "$TXTINFO Firmware flashed."
  
  echo -e "$TXTINFO All done. you can now unplug the programming cable."
  cd ~
  rm -rf ./md380tools
  
  exit 0
fi

if [[ "$1" == "--csv" ]]
then
  git clone https://github.com/travisgoodspeed/md380tools.git
  cd md380tools
  make clean

 ##### turn radio normally on to begin database loading with USB cable #####
  echo -e "$TXTINFO Turn on the radio in normally and plug in the programming cable."
  read -p "Once done, press [Enter] key to start flashing..."
  make flashdb
  echo -e "$TXTINFO UsersCSV flashed."
  
  echo -e "$TXTINFO All done. you can now unplug the programming cable."
  cd ~
  rm -rf ./md380tools
  
  exit 0
fi

if [[ "$1" == "--help" ]]
then
  echo "Usage: md380 [OPTION]"
  echo "Flash the md380tools firmware (https://github.com/travisgoodspeed/md380tools) and/or upload the UsersCSV database"
  echo
  echo -e "\t--fw\t\tDownload and flash the last md380tools firmware from Github"
  echo -e "\t--csv\t\tUpload to the radio the list of the DMR IDs"
  echo -e "\t--all\t\tPerform --fw and --csv (faster than running them separately)"
  exit 0
fi

echo "md380: missing argument" 
echo "Try 'md380 --help' for more information" 
