FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Build the gateway
WORKDIR ~/ttn-gateway
COPY resin-install.sh .
RUN ./resin-install.sh

# Make sure we start up within the bin directory
WORKDIR /opt/ttn-gateway/bin
COPY resin-run.sh .

# Start it up
CMD ["sh", "-c", "./resin-run.sh"]
