FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Build the gateway
COPY resin-install.sh /ttn-gateway/resin-install.sh
WORKDIR /ttn-gateway
RUN ./resin-install.sh

# Make sure we start up within the bin directory
COPY resin-run.sh /opt/ttn-gateway/bin/resin-run.sh
WORKDIR /opt/ttn-gateway/bin

# Start it up
CMD ["sh", "-c", "./resin-run.sh"]
