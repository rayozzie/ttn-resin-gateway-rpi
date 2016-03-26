FROM resin/raspberrypi-buildpack-deps

# Enable systemd, as Resin requires this
ENV INITSYSTEM on

# Version number of gateway software.
# (Incrementing this simply forces Docker to flush its cache
#  and thus forces a full rebuild. Not used outside of Dockerfile.)
ENV TTN_GATEWAY_SOFTWARE 48

# Build the gateway
COPY build.sh /opt/ttn-gateway/dev/build.sh
WORKDIR /opt/ttn-gateway/dev
RUN ./build.sh && rm -rf /opt/ttn-gateway/dev

# Copy the run shell script after build, so we can modify it without rebuilding
COPY run.sh /opt/ttn-gateway/run.sh
WORKDIR /opt/ttn-gateway

# Start it up
CMD ["sh", "-c", "./run.sh"]
