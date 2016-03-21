#! /bin/bash

# Reset gateway ID based on MAC
./packet_forwarder/reset_pkt_fwd.sh start ./bin/local_conf.json

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
    echo "[TTN Gateway]: Packet forwarder exited; retrying in 15s..."
    sleep 15
  done
