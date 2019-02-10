#!/bin/sh

cd /home/pi/ugateway-scripts

read -p "Make a selection, then press ENTER. 1=AS923 or 2=AS915 (we recommend AS923): " region

if [ $region = "1" ]; then
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AS1-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    rm .settings
    echo "AS923" >> .settings
else
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AU-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
    rm .settings
    echo "AU915" >> .settings 
fi
 
read -p "Press ENTER to close" key
