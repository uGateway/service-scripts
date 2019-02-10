#!/bin/sh

read -p "Make a selection, then press ENTER. 1=AS923 or 2=AS915 (we recommend AS923): " region

if [ $region = "1" ]; then
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AS1-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
else
    sudo wget https://raw.githubusercontent.com/TheThingsNetwork/gateway-conf/master/AU-global_conf.json -O /opt/ttn-gateway/bin/global_conf.json
fi
 
read -p "Press ENTER to close" key
