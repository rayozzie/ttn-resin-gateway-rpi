FROM resin/raspberrypi-buildpack-deps

# Enable systemd
ENV INITSYSTEM on

# Build the gateway
COPY build.sh /ttn-gateway/build.sh
WORKDIR /ttn-gateway
RUN ./build.sh

# Copy the run shell script after build, so we can modify it without rebuilding
COPY run.sh /opt/ttn-gateway/bin/run.sh
WORKDIR /opt/ttn-gateway/bin

# Start it up
CMD ["sh", "-c", "./run.sh"]
