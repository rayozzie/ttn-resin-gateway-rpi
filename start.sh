#! /bin/bash

# Display the environment, which is useful when debugging

echo "**************************************************************"
echo "**************************************************************"
echo "Environment:"
env
echo "**************************************************************"
echo "**************************************************************"
echo ""

# Configure the global and local configuration files via the environment

echo "**************************************************************"
echo "**************************************************************"
echo "Gateway Configuration:"
echo "**************************************************************"
echo "**************************************************************"

if [[ $GATEWAY_NAME == "" ]]; then
    echo "ERROR: NO GATEWAY_NAME FOUND IN ENVIRONMENT"
    exit 1
fi
echo GATEWAY_NAME: $GATEWAY_NAME

if [[ $GATEWAY_EMAIL == "" ]]; then
    echo "ERROR: NO GATEWAY_EMAIL FOUND IN ENVIRONMENT"
    exit 1
fi
echo GATEWAY_EMAIL: $GATEWAY_EMAIL

if [[ $GATEWAY_LAT == "" ]]; then
    echo "ERROR: NO GATEWAY_LAT (latitude) FOUND IN ENVIRONMENT"
    exit 1
fi
echo GATEWAY_LAT: $GATEWAY_LAT

if [[ $GATEWAY_LON == "" ]]; then
    echo "ERROR: NO GATEWAY_LON (longitude) FOUND IN ENVIRONMENT"
    exit 1
fi
echo GATEWAY_LON: $GATEWAY_LON

if [[ $GATEWAY_ALT == "" ]]; then
    echo "ERROR: NO GATEWAY_ALT (altitude) FOUND IN ENVIRONMENT"
    exit 1
fi
echo GATEWAY_ALT: $GATEWAY_ALT

echo "**************************************************************"
echo "**************************************************************"
echo ""

echo -e "{\n\t\"gateway_conf\": {\n\t\t\"gateway_ID\": \"0000000000000000\",\n\t\t\"servers\": [ { \"server_address\": \"croft.thethings.girovito.nl\", \"serv_port_up\": 1700, \"serv_port_down\": 1701, \"serv_enabled\": true } ],\n\t\t\"ref_latitude\": $GATEWAY_LAT,\n\t\t\"ref_longitude\": $GATEWAY_LON,\n\t\t\"ref_altitude\": $GATEWAY_ALT,\n\t\t\"contact_email\": \"$GATEWAY_EMAIL\",\n\t\t\"description\": \"$GATEWAY_NAME\" \n\t}\n}" >./local_conf.json

# Reset gateway ID based on MAC
../packet_forwarder/reset_pkt_fwd.sh start ./local_conf.json

# Display gateway ID, which is very important for debugging

echo "**************************************************************"
echo "**************************************************************"
grep gateway_ID local_conf.json
echo "**************************************************************"
echo "**************************************************************"
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
	echo "**************************************************************"
	echo "**************************************************************"
    echo "[TTN Gateway]: Packet forwarder exited; retrying in 15s..."
	echo "**************************************************************"
	echo "**************************************************************"
    sleep 15
  done
