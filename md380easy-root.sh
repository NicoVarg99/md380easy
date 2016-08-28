#!/bin/bash

if [ $(id -u) -ne 0 ]; then
  if [ -f /usr/bin/md380 ]; then
    bash /usr/bin/md380
  else
	  echo "[ERROR] This script must be run as root." >&2 
	  exit 1
	fi
fi

echo md380easy-root
