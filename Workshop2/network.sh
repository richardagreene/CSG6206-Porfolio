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
cpu_time="$(uptime | tail -c 6)"; 
echo "------------------------ System Report ---------------------------"
echo "Date: $current_date	Time: $current_time 	System Name: $HOSTNAME"
echo "------------------------------------------------------------------"
uptime | awk -F'(up|,)+' '{ printf "Uptime: %s \n", $2}'
uptime | awk -F'(,)+' '{ printf "Current Users: %s \n", $2 }'
echo "CPU Load: $cpu_time"
echo "Current Network: $current_network"
echo "-------------------------- End Report ----------------------------"
exit 0  # everything returned fine
