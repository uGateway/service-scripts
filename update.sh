#!/bin/bash

# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[uGateway]: Waiting for internet connection..."
  sleep 5
  done

# Ensure we're in the right directory
cd /home/pi/ugateway-scripts

# Check for changes on Github (this will revert system files while leaving custom user files intact)
echo "Updating service scripts..."

# reset permissions and revert custom changes
sudo chown -R pi:pi .
git checkout .

OLD_HEAD=$(git rev-parse HEAD)
git pull
NEW_HEAD=$(git rev-parse HEAD)

# Echo out the result - not needed I guess..
if [[ $OLD_HEAD != $NEW_HEAD ]]; then
    echo "Updates found and installed"
else
    echo "No updates found"
fi

# append the activity log
echo `date` >> update.log
