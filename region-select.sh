#!/bin/bash

cd /home/pi/ugateway-scripts

# Test the connection, wait if needed.
echo "Waiting for an internet connection (If issues - have you updated WiFi password?)"
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[uGateway]: Waiting for internet connection..."
  sleep 30
  done
clear

# Get first non-loopback network device that is currently connected
GATEWAY_EUI_NIC=$(ip -oneline link show up 2>&1 | grep -v LOOPBACK | sed -E 's/^[0-9]+: ([0-9a-z]+): .*/\1/' | head -1)
if [[ -z $GATEWAY_EUI_NIC ]]; then
    read -p "ERROR: Can't detect LoRa module, will exit after ENTER is pressed" key
    exit 1
fi

# Then get EUI based on the MAC address of that device
GATEWAY_EUI=$(cat /sys/class/net/$GATEWAY_EUI_NIC/address | awk -F\: '{print $1$2$3"FFFE"$4$5$6}')
GATEWAY_EUI=${GATEWAY_EUI^^} # toupper

# Update Gateway ID
sudo sed -i '/gateway_ID/c\"gateway_ID": "$GATEWAY_EUI",' /opt/ttn-gateway/bin/local_conf.json

echo "Gateway ID: $GATEWAY_EUI"
echo " "
read -p "Make a selection, then press ENTER. 1=AS923 or 2=AS915 (we recommend AS923): " region

if [ $region = "1" ]; then
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AS1-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AS923" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethings.network", "serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /opt/ttn-gateway/bin/local_conf.json
else
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AU-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AU915" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethings.network", "serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /opt/ttn-gateway/bin/local_conf.json
fi

bash soft-restart.sh &

echo "Note - uGateway is configured to use router.as1.thethings.network - this is the same for AS923 / AU915"
echo " "
echo "uGateway might take a minute or so to reconnect to TTN"
echo " "
read -p "Press ENTER to close" key
