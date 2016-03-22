FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Build the gateway
COPY resin-install.sh /ttn-gateway/resin-install.sh
WORKDIR /ttn-gateway
RUN ./resin-install.sh

# Copy the run shell script after build, so we can modify it without rebuilding
COPY resin-run.sh /opt/ttn-gateway/bin/resin-run.sh

# Start it up
CMD ["sh", "-c", "/opt/ttn-gateway/bin/resin-run.sh"]
