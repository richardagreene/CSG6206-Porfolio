#!/bin/bash
clear
if ! ping -q -c 1 proxy.ecu.edu.au &> /dev/null 
then
    echo "You are not connected to the ECU Network"
    exit
fi
current_date="$(date +'%d/%m/%Y')";
current_time="$(date +%H:%M:%S)";
current_system=$(system_profiler SPSoftwareDataType | grep "Computer Name:" | awk -F'(:)+' '{ printf "%s", $2 }') 
echo "------------------------ System Report ---------------------------"
echo "Date: $current_date	Time: $current_time 	System Name: $current_system"
echo "------------------------------------------------------------------"
uptime | awk -F'( |,|:)+' '{ printf "Uptime: %s days %s hours %s minutes\n", $3, $4, $5 }'
uptime | awk -F'( |,|:)+' '{ printf "Current Users: %s \n", $6 }'
uptime | awk -F'( |,|:)+' '{ printf "CPU Load: %s \n", $10 }'
echo "Current Network: $current_system"
echo "-------------------------- End Report ----------------------------"
