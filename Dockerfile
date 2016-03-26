FROM resin/raspberrypi-buildpack-deps

# Enable systemd, as Resin requires this
ENV INITSYSTEM on

# Another approach to blowing away the cache
RUN date >/var/tmp/image_build.log

# Version number of gateway software.
# (Incrementing this simply forces Docker to flush its cache
#  and thus forces a full rebuild. Not used outside of Dockerfile.)
ENV TTN_GATEWAY_SOFTWARE 46

# Build the gateway
COPY build.sh /tmp/build.sh
WORKDIR /tmp
RUN ./build.sh

# Copy the run shell script after build, so we can modify it without rebuilding
COPY run.sh /opt/ttn-gateway/run.sh
WORKDIR /opt/ttn-gateway

# Start it up
CMD ["sh", "-c", "./run.sh"]
