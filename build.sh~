#! /bin/bash

# Stop on the first sign of trouble
set -e

if [ $UID != 0 ]; then
    echo "ERROR: Operation not permitted. Forgot sudo?"
    exit 1
fi

VERSION="master"
if [[ $1 != "" ]]; then VERSION=$1; fi

echo "The Things Network Gateway installer"
echo ""

# We will build in a place that we will purge after build,
# and will install just the required files in the appropriate place

BUILD_DIR="/tmp/ttn-gateway"
INSTALL_DIR="/opt/ttn-gateway"

if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
if [ ! -d "$BUILD_DIR" ]; then mkdir $BUILD_DIR; fi

pushd $BUILD_DIR

# Build WiringPi
if [ ! -d wiringPi ]; then
    git clone git://git.drogon.net/wiringPi
    pushd wiringPi
else
    pushd wiringPi
    git reset --hard
    git pull
fi

./build

popd

# Build LoRa gateway app for this specific platform
if [ ! -d lora_gateway ]; then
    git clone https://github.com/TheThingsNetwork/lora_gateway.git
    pushd lora_gateway
else
    pushd lora_gateway
    git reset --hard
    git pull
fi

sed -i -e 's/PLATFORM= kerlink/PLATFORM= imst_rpi/g' ./libloragw/library.cfg
# sed -i -e 's/DEBUG_HAL= 0/DEBUG_HAL= 1/g' ./libloragw/library.cfg

make

popd

# Build packet forwarder
if [ ! -d packet_forwarder ]; then
    git clone https://github.com/TheThingsNetwork/packet_forwarder.git
    pushd packet_forwarder
else
    pushd packet_forwarder
    git pull
    git reset --hard
fi

make

popd

# Restore location back to where we started the build
popd

# Copy packet forwarder to where we will need it
cp $BUILD_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd $INSTALL_DIR/poly_pkt_fwd

# Delete the build folder so that we save space
rm -rf $BUILD_DIR

echo "Build completed."
