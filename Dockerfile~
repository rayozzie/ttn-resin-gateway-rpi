FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Copy the installer
COPY . ~/ttn-gateway

# Build the gateway
WORKDIR ~/ttn-gateway
RUN ./resin-install.sh

# Make sure we start up within the bin directory
WORKDIR /opt/ttn-gateway/bin

# Start it up
CMD ["sh", "-c", "./resin-run.sh"]
