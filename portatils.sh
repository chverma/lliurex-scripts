#!/usr/bin/env bash


# At the SERVER_HOST you have to run: nc -k -l 1234
# Connect the netbooks via ethernet cable
# Execute 'python3 -m http.server' where this script resides. This command serves the script to the clients

# Connect to devices:
# cssh -lAdministrador $(sudo nmap -sn NETWORK_IP/24 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tr '\n' ' ') -a 'wget -O /tmp/portatils.sh SERVER_HOST:8000/portatils.sh; chmod +x /tmp/portatils.sh; /tmp/portatils.sh'
# Example:
# cssh -lAdministrador $(sudo nmap -sn 192.168.211.0/24 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tr '\n' ' ') -a 'wget -O /tmp/portatils.sh 192.168.211.122:8000/portatils.sh; chmod +x /tmp/portatils.sh; /tmp/portatils.sh'

## Password of the Administrador user on Lliurex
SUDOPASSWD=REPLACE

## Enable guest user
llx-guest-manager enable


## Create the Wi-Fi connection
SYSTEM_CONN=/etc/NetworkManager/system-connections/
OLD_SSID=MYSSID
OLD_PASSWD=MYPASSWD
OLD_UUID=MYUUID

## SSID Name to connect
NEWSSID=REPLACE
## Password of the SSID
NEWPASSWD=REPLACE

## Use the educaendigital connection to get UUID
NAME=educaendigital
NEWUUID=$(nmcli -t -f name,uuid connection | grep $NAME | cut -d":" -f2 | sed "s/\-/\\\-/g")


echo $SUDOPASSWD | sudo -S wget -O $SYSTEM_CONN$NEWSSID https://raw.githubusercontent.com/chverma/lliurex-scripts/master/template_wifi

echo $SUDOPASSWD | sudo -S chmod 600 $SYSTEM_CONN$NEWSSID

echo $SUDOPASSWD | sudo -S sed -i  -e "s/$OLD_SSID/$NEWSSID/g" -e "s/$OLD_PASSWD/$NEWPASSWD/g" -e "s/$OLD_UUID/$NEWUUID/g" $SYSTEM_CONN$NEWSSID

## Get the MAC address
DEVICE=wlan0
SERVER_HOST=REPLACE
SERVER_PORT=1234
cat /sys/class/net/$DEVICE/address | nc -q1 $SERVER_HOST $SERVER_PORT && echo $SUDOPASSWD | sudo -S reboot
