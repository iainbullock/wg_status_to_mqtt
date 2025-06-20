#!/bin/ash
set -e

echo Starting wg_status_to_mqtt container....
echo Iain Bullock June 2025
echo https://github.com/iainbullock/wg_status_to_mqtt

# Load subroutines
. /app/version.sh
. /app/subroutines.sh

# Initialise config files if not done previously
if [ ! -f /config/friendly_names.conf ]; then
 echo -e "Creating default friendly_names.conf file"
 cp -n /conf/friendly_names.conf /config
fi

# Export environment setting defaults if not defined
export MQTT_IP=${MQTT_IP:-127.0.0.1}
export MQTT_PORT=${MQTT_PORT:-1883}
export MQTT_USERNAME=${MQTT_USERNAME:-user}
export MQTT_PASSWORD=${MQTT_PASSWORD:-pass}
export POLL_DELAY=${POLL_DELAY:=120}
export DEVICE_NAME=${DEVICE_NAME:=Wireguard}

echo "Configuration options are:
  MQTT_IP=$MQTT_IP
  MQTT_PORT=$MQTT_PORT
  MQTT_USERNAME=$MQTT_USERNAME
  MQTT_PASSWORD=Not Shown
  POLL_DELAY=$POLL_DELAY
  DEVICE_NAME=$DEVICE_NAME"

# Main Loop
while :; do
  # Publish autodiscovery messages every 10th iteration of the sub loop
  update_autodiscovery
  
  # Sub loop which updates values every time
  i=0
  while [ $i -le 10 ]; do
    echo Sleeping for $POLL_DELAY secs
    sleep $POLL_DELAY
    i=$((i + 1))
    
    update_values
  done

done

echo Error Main Loop terminated unexpectedly
