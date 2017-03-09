#!/bin/bash
clear
# Test the network.
if ping -c 1 proxy.ecu.edu.au &> /dev/null 
then
    current_network="ECU";
else
    current_network="External";
fi
current_date="$(date +'%d/%m/%Y')";
current_time="$(date +%H:%M:%S)";
echo "------------------------ System Report ---------------------------"
echo "Date: $current_date	Time: $current_time 	System Name: $HOSTNAME"
echo "------------------------------------------------------------------"
uptime | awk -F'( |,|:)+' '{ printf "Uptime: %s days %s hours %s minutes\n", $3, $4, $5 }'
uptime | awk -F'( |,|:)+' '{ printf "Current Users: %s \n", $6 }'
uptime | awk -F'( |,|:)+' '{ printf "CPU Load: %s \n", $10 }'
echo "Current Network: $current_network"
echo "-------------------------- End Report ----------------------------"
