#! /bin/bash

# Stop on the first sign of trouble
set -e

echo "The Things Network RPi + IC880A Gateway Builder/Installer"
echo ""

# Build in a temp folder that we'll completely  purge after build,
# and install into the linux folder where apps reside.

BUILD_DIR="/tmp/ttn-gateway"
mkdir $BUILD_DIR

INSTALL_DIR="/opt/ttn-gateway"
mkdir $INSTALL_DIR

# Switch to where we'll do the builds
pushd $BUILD_DIR

# Build WiringPi so that we can do Raspberry Pi I/O
git clone git://git.drogon.net/wiringPi
pushd wiringPi
./build
popd

# Build LoRa gateway app for this specific platform
git clone https://github.com/TheThingsNetwork/lora_gateway.git
pushd lora_gateway
sed -i -e 's/PLATFORM= kerlink/PLATFORM= imst_rpi/g' ./libloragw/library.cfg
# Comment the following in or out as needed for hardware debugging
#sed -i -e 's/DEBUG_AUX= 0/DEBUG_AUX= 1/g' ./libloragw/library.cfg
sed -i -e 's/DEBUG_SPI= 0/DEBUG_SPI= 1/g' ./libloragw/library.cfg
sed -i -e 's/DEBUG_REG= 0/DEBUG_REG= 1/g' ./libloragw/library.cfg
sed -i -e 's/DEBUG_HAL= 0/DEBUG_HAL= 1/g' ./libloragw/library.cfg
#sed -i -e 's/DEBUG_GPS= 0/DEBUG_GPS= 1/g' ./libloragw/library.cfg
make
popd

# Build the packet forwarder
git clone https://github.com/TheThingsNetwork/packet_forwarder.git
pushd packet_forwarder
make
popd

# Restore location back to where we were prior to starting the build
popd

# Copy packet forwarder to where it'll be expected
cp $BUILD_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd $INSTALL_DIR/poly_pkt_fwd

# Delete the build folder so that we save space
rm -rf $BUILD_DIR

echo "Build & Installation Completed."
