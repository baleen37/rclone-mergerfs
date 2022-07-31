FROM ubuntu:22.04

#
# BUILD
#
FROM ubuntu AS builder
# update
RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
        ca-certificates curl unzip fuse
# install rclone
RUN curl https://rclone.org/install.sh | bash
# install mergerfs.sh
RUN apt-get install mergerfs

# clean up APT when done
RUN apt-get clean -qq && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
## add local files
#COPY root/ /bar/
#
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/adduser /bar/etc/cont-init.d/10-adduser
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/install-pkg /bar/etc/cont-init.d/20-install-pkg
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/wait-for-mnt /bar/etc/cont-init.d/30-wait-for-mnt

VOLUME /config /local /remote /merged
WORKDIR /data
#
#HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 \
#    CMD /usr/local/bin/healthcheck
#
#ENTRYPOINT ["/init"]
