FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Copy all the source code to the place where golang will find it
COPY . ~/ttn-gateway

# Build the gateway
WORKDIR ~/ttn-gateway
RUN ./install.sh

# Make sure we start up within the bin directory
WORKDIR /opt/ttn-gateway/bin

# Start it up
CMD ["sh", "-c", "./start.sh"]
