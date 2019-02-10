#!/bin/sh

cd /home/pi/ugateway-scripts

read -p "Make a selection, then press ENTER. 1=AS923 or 2=AS915 (we recommend AS923): " region

if [ $region = "1" ]; then
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AS1-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AS923" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethingsnetwork", serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /tmp/foo
else
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AU-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    [ -e .region ] && rm .region
    echo "AU915" >> .region
    sudo sed -i '/thethings.network/c\"servers": [ { "server_address": "router.as1.thethingsnetwork", serv_port_up": 1700, "serv_port_down": 1700, "serv_enabled": true } ],' /tmp/foo
fi

read -p "Press ENTER to close" key
