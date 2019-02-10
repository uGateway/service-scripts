#!/bin/sh

cd /home/pi/ugateway-scripts

read -p "Make a selection, then press ENTER. 1=AS923 or 2=AS915 (we recommend AS923): " region

if [ $region = "1" ]; then
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AS1-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AS923" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethings.network", serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /opt/ttn-gateway/bin/local_conf.json
else
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AU-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AU915" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethings.network", serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /opt/ttn-gateway/bin/local_conf.json
fi

bash soft-restart.sh &

echo "Note - uGateway is configured to use router.as1.thethings.network - this is the same for AS923 / AU915"
echo " "
echo "uGateway might take a minute or so to reconnect to TTN)"
echo " "
read -p "Press ENTER to close" key
