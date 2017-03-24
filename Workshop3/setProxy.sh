#!/bin/bash
clear

# see if the the Proxy is connected
function checkNetwork()
{ 
    # Test the network.
    if ping -c 1 proxy.ecu.edu.au &> /dev/null 
    then
        echo "You are on an ECU network";
        return 0
    else
        echo "You are off campus"
        return 1
    fi
}

# Clear the settings
function clearProxySettings()
{
    sed -i -n '/export/!p' /etc/environment
    rm -f /etc/apt/apt.conf.d/95proxies
    echo "Proxy settings have been cleared"
}

# Set the proxy settings on the machine
function setupProxySettings()
{
    # reference http://askubuntu.com/questions/150210/how-do-i-set-systemwide-proxy-servers-in-xubuntu-lubuntu-or-ubuntu-studio
    echo -n "Please enter your ECU username: "; read username
    echo -n "Please enter your ECU password: "; read -s password
    echo "export http_proxy=http://$username:$password@proxy.ecu.edu.au:80" >> /etc/environment
    echo "export HTTP_PROXY=http://$username:$password@proxy.ecu.edu.au:443" >> /etc/environment
    echo "export https_proxy=https://$username:$password@proxy.ecu.edu.au:443" >> /etc/environment
    echo "export HTTPS_PROXY=https://$username:$password@proxy.ecu.edu.au:80" >> /etc/environment
    echo "export no_proxy=localhost,127.0.0.0/8,*.local" >> /etc/environment
    echo "export NO_PROXY=localhost,127.0.0.0/8,*.local" >> /etc/environment
    printf \
        "Acquire::http::proxy \"http://$username:$password@proxy.ecu.edu.au:80/\";\n\
Acquire::https::proxy \"https://$username:$password@proxy.ecu.edu.au:443/\";\n" > /etc/apt/apt.conf.d/95proxies;
    echo -e "\n Your proxy has been set!\n"
}

## Main Program Start
if [ $(id -u) -ne 0 ]; then
  echo "This script must be run as root";
  echo " Syntax: sudo bash <scriptname>";
  exit 1;
fi
echo "Detecting network location..."
checkNetwork
if [ $? -eq 0 ]
then
    setupProxySettings
else
    clearProxySettings
fi 
