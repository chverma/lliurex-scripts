#!/usr/bin/env bash


# At the SERVER_HOST you have to run: nc -k -l 1234
# Connect the netbooks via ethernet cable
# Connect to devices:
# cssh -lAdministrador $(sudo nmap -sn MY_NETWORK_IP/24 | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | tr '\n' ' ') -a 'scp myuser@MY_HOST:/path/to/this/script /tmp/portatils.sh; chmod +x /tmp/portatils.sh; ./portatils.sh'

llx-guest-manager enable


SYSTEM_CONN=/etc/NetworkManager/system-connections/
OLD_SSID=MYSSID
OLD_PASSWD=MYPASSWD
OLD_UUID=MYUUID

NEWSSID=REPLACE
NEWPASSWD=REPLACE
DEVICE=wlan0
NEWUUID=$(nmcli -t -f device,uuid connection | grep $DEVICE | cut -d":" -f2)

SERVER_HOST=REPLACE
SERVER_PORT=1234
sudo wget -O $SYSTEM_CONN$NEWSSID https://raw.githubusercontent.com/chverma/lliurex-scripts/master/template_wifi

sudo chmod 600 $SYSTEM_CONN$NEWSSID

sudo sed -i  -e "s/$OLD_SSID/$NEWSSID/g" -e "s/$OLD_PASSWD/$NEWPASSWD/g" -e "s/$OLD_UUID/$NEWUUID/g" $SYSTEM_CONN$NEWSSID

cat /sys/class/net/$DEVICE/address | nc -q1 $SERVER_HOST $SERVER_PORT && sudo reboot
