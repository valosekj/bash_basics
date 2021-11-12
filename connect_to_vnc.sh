#!/bin/bash

# Script for opening VNCviewer,  JV 2018-2021
# You can use the script as a launcher

read -p "Enter VNC session number: "  vnc_number

if [[ ${vnc_number} == "" ]];then
  vnc_number=3
fi

vncviewer localhost:${vnc_number}
