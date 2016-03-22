#! /bin/bash

# Display the environment, which is useful when debugging

echo "******************"
echo "*** Environment:"
env
echo "******************"
echo ""

# Configure the global and local configuration files via the environment

echo "******************"
echo "*** Configuration:"
echo "******************"

if [[ $GATEWAY_REGION == "" ]]; then
    echo "ERROR: NO GATEWAY_REGION FOUND IN ENVIRONMENT"
    while true; do sleep 10; done
fi
echo GATEWAY_REGION: $GATEWAY_REGION

if [[ $GATEWAY_NAME == "" ]]; then
    echo "ERROR: NO GATEWAY_NAME FOUND IN ENVIRONMENT"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi
echo GATEWAY_NAME: $GATEWAY_NAME

if [[ $GATEWAY_EMAIL == "" ]]; then
    echo "ERROR: NO GATEWAY_EMAIL FOUND IN ENVIRONMENT"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi
echo GATEWAY_EMAIL: $GATEWAY_EMAIL

if [[ $GATEWAY_LAT == "" ]]; then
    echo "ERROR: NO GATEWAY_LAT (latitude) FOUND IN ENVIRONMENT"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi
echo GATEWAY_LAT: $GATEWAY_LAT

if [[ $GATEWAY_LON == "" ]]; then
    echo "ERROR: NO GATEWAY_LON (longitude) FOUND IN ENVIRONMENT"
    while true; do sleep 10; done # don't exit in resin
	exit 1
fi
echo GATEWAY_LON: $GATEWAY_LON

if [[ $GATEWAY_ALT == "" ]]; then
    echo "ERROR: NO GATEWAY_ALT (altitude) FOUND IN ENVIRONMENT"
    while true; do sleep 10; done # don't exit in resin
    exit 1
fi
echo GATEWAY_ALT: $GATEWAY_ALT

echo "******************"
echo ""

# load the region-appropriate global conf

if curl --fail "https://raw.githubusercontent.com/rayozzie/ttn-gateway-conf/master/$GATEWAY_REGION-global-conf.json --output ./global-conf.json
then
	sleep 1
else
	echo "******************"
    echo "ERROR: GATEWAY_REGION not found"
	echo "******************"
    while true; do sleep 10; done # don't exit in resin
    exit 1
fi

# create local.conf

echo -e "{\n\t\"gateway_conf\": {\n\t\t\"gateway_ID\": \"0000000000000000\",\n\t\t\"servers\": [ { \"server_address\": \"croft.thethings.girovito.nl\", \"serv_port_up\": 1700, \"serv_port_down\": 1701, \"serv_enabled\": true } ],\n\t\t\"ref_latitude\": $GATEWAY_LAT,\n\t\t\"ref_longitude\": $GATEWAY_LON,\n\t\t\"ref_altitude\": $GATEWAY_ALT,\n\t\t\"contact_email\": \"$GATEWAY_EMAIL\",\n\t\t\"description\": \"$GATEWAY_NAME\" \n\t}\n}" >./local_conf.json

# Reset gateway ID based on MAC

echo "******************"
../packet_forwarder/reset_pkt_fwd.sh start ./local_conf.json
echo "******************"
echo ""

# Test the connection, wait if needed.
while [[ $(ping -c1 google.com 2>&1 | grep " 0% packet loss") == "" ]]; do
  echo "[TTN Gateway]: Waiting for internet connection..."
  sleep 30
  done

# Fire up the forwarder.  
while true
  do
    echo "[TTN Gateway]: Starting packet forwarder..."
    ./poly_pkt_fwd
	echo "******************"
    echo "*** [TTN Gateway]: EXIT (retrying in 15s)"
	echo "******************"
    sleep 15
  done
