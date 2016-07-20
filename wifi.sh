#!/bin/bash

echo "Enter the SSID of your wifi network"
read SSID

echo "Enter the password for $SSID"
read PASSWORD

# The wpa_passphrase command writes a barebones wpa_supplicant config file
# Add any extra settings or alternate networks to this file
sudo wpa_passphrase $SSID $PASSWORD > /etc/wpa_supplicant.conf

# The following stanza should be appended to /etc/network/interfaces only once
echo "
auto wlan0
iface wlan0 inet dhcp
pre-up wpa_supplicant -B -iwlan0 -c /etc/wpa_supplicant.conf
post-down killall -q wpa_supplicant
" > .interface
sudo cat .interface >> /etc/network/interfaces

# This allows ssh mybox.local instead of ssh 192.168.1.123
sudo apt-get install avahi-daemon

HOST=`hostname`
echo "Finished setting up wifi. Restart and try: ssh ${HOST}.local"
