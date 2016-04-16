#! /bin/bash

# Stop on the first sign of trouble
set -e

echo "The Things Network Raspberry Pi Gateway Builder/Installer"
echo ""

# Build in a temp folder that we'll completely  purge after build,
# and install into the linux folder where apps reside.

INSTALL_DIR="/opt/ttn-gateway"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi

BUILD_DIR="$INSTALL_DIR/dev"
if [ ! -d "$BUILD_DIR" ]; then mkdir $BUILD_DIR; fi

# Switch to where we'll do the builds
pushd $BUILD_DIR

# Build WiringPi so that we can do Raspberry Pi I/O
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
# Comment the following in or out as needed for hardware debugging
#sed -i -e 's/DEBUG_SPI= 0/DEBUG_SPI= 1/g' ./libloragw/library.cfg
#sed -i -e 's/DEBUG_REG= 0/DEBUG_REG= 1/g' ./libloragw/library.cfg
#sed -i -e 's/DEBUG_HAL= 0/DEBUG_HAL= 1/g' ./libloragw/library.cfg
#sed -i -e 's/DEBUG_AUX= 0/DEBUG_AUX= 1/g' ./libloragw/library.cfg
#sed -i -e 's/DEBUG_GPS= 0/DEBUG_GPS= 1/g' ./libloragw/library.cfg
make
popd

# Build the packet forwarder
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

# Restore location back to where we were prior to starting the build
popd

# Copy things needed at runtime to where they'll be expected
cp $BUILD_DIR/packet_forwarder/reset_pkt_fwd.sh $INSTALL_DIR/set-gateway-id.sh
cp $BUILD_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd $INSTALL_DIR/ttn-gateway

echo "Build & Installation Completed."
