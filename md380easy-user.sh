#!/bin/bash

if [ $(id -u) -eq 0 ]; then
    sudo bash /usr/sbin/md380
    exit 0
fi





echo md380easy-user
