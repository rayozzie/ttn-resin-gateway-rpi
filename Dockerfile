FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Build the gateway
COPY build.sh /tmp/build.sh
WORKDIR /tmp
RUN ./build.sh

# Copy the run shell script after build, so we can modify it without rebuilding
COPY run.sh /opt/ttn-gateway/run.sh
WORKDIR /opt/ttn-gateway

# Start it up
CMD ["sh", "-c", "./run.sh"]
