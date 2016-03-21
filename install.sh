#!/bin/bash

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

# Check dependencies
echo "Installing dependencies..."
apt-get update
apt-get install swig libftdi-dev python-dev

# Install LoRaWAN packet forwarder repositories
INSTALL_DIR="/opt/ttn-gateway"
if [ ! -d "$INSTALL_DIR" ]; then mkdir $INSTALL_DIR; fi
pushd $INSTALL_DIR

# Build libraries
if [ ! -d libmpsse ]; then
    git clone https://github.com/devttys0/libmpsse.git
    pushd libmpsse/src
else
    pushd libmpsse/src
    git reset --hard
    git pull
fi

./configure --disable-python
make
make install
ldconfig

popd

# Build LoRa gateway app
if [ ! -d lora_gateway ]; then
    git clone https://github.com/TheThingsNetwork/lora_gateway.git
    pushd lora_gateway
else
    pushd lora_gateway
    git reset --hard
    git pull
fi

cp ./libloragw/99-libftdi.rules /etc/udev/rules.d/99-libftdi.rules

sed -i -e 's/CFG_SPI= native/CFG_SPI= ftdi/g' ./libloragw/library.cfg
sed -i -e 's/PLATFORM= kerlink/PLATFORM= lorank/g' ./libloragw/library.cfg
sed -i -e 's/ATTRS{idProduct}=="6010"/ATTRS{idProduct}=="6014"/g' /etc/udev/rules.d/99-libftdi.rules

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

# Symlink poly packet forwarder
if [ ! -d bin ]; then mkdir bin; fi
if [ -f ./bin/poly_pkt_fwd ]; then rm ./bin/poly_pkt_fwd; fi
ln -s $INSTALL_DIR/packet_forwarder/poly_pkt_fwd/poly_pkt_fwd ./bin/poly_pkt_fwd
cp -f ./packet_forwarder/poly_pkt_fwd/global_conf.json ./bin/global_conf.json

# Restore location back to where we started the install

popd

# Copy startup shell script to the install directory

cp ./start.sh $INSTALL_DIR/bin/start.sh

echo "Installation completed."
