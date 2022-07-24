FROM ubuntu:22.04 AS ubuntu

#
# BUILD
#
FROM ubuntu AS builder
# update
RUN apt-get update -qq && \
    apt-get install -yq --no-install-recommends \
        ca-certificates curl unzip
# install rclone
RUN curl https://rclone.org/install.sh | sudo bash
# install mergerfs.sh
RUN curl https://rclone.org/install.sh | sudo bash

# clean up APT when done
RUN apt-get clean -qq && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
#
## add local files
#COPY root/ /bar/
#
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/adduser /bar/etc/cont-init.d/10-adduser
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/install-pkg /bar/etc/cont-init.d/20-install-pkg
#ADD https://raw.githubusercontent.com/by275/docker-base/main/_/etc/cont-init.d/wait-for-mnt /bar/etc/cont-init.d/30-wait-for-mnt

#
# RELEASE
#
FROM ubuntu

# add build artifacts
#COPY --from=builder /bar/ /

## install packages
#RUN \
#    echo "**** apt source change for local build ****" && \
#    sed -i "s/archive.ubuntu.com/$APT_MIRROR/g" /etc/apt/sources.list && \
#    echo "**** install runtime packages ****" && \
#    apt-get update && \
#    apt-get install -yq --no-install-recommends apt-utils && \
#    apt-get install -yq --no-install-recommends \
#        bc \
#        ca-certificates \
#        fuse \
#        jq \
#        lsof \
#        openssl \
#        tzdata \
#        unionfs-fuse \
#        wget && \
#    update-ca-certificates && \
#    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf && \
#    echo "**** add mergerfs.sh ****" && \
#    MFS_VERSION=$(wget --no-check-certificate -O - -o /dev/null "https://api.github.com/repos/trapexit/mergerfs/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
#    MFS_DEB="mergerfs_${MFS_VERSION}.ubuntu-focal_$(dpkg --print-architecture).deb" && \
#    cd $(mktemp -d) && wget --no-check-certificate "https://github.com/trapexit/mergerfs/releases/download/${MFS_VERSION}/${MFS_DEB}" && \
#    dpkg -i ${MFS_DEB} && \
#    echo "**** create abc user ****" && \
#    useradd -u 911 -U -d /config -s /bin/false abc && \
#    usermod -G users abc && \
#    echo "**** permissions ****" && \
#    chmod a+x /usr/local/bin/* && \
#    echo "**** cleanup ****" && \
#    apt-get clean autoclean && \
#    apt-get autoremove -y && \
#    rm -rf /tmp/* /var/lib/{apt,dpkg,cache,log}/
#
## environment settings
#ENV \
#    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
#    S6_KILL_FINISH_MAXTIME=7000 \
#    S6_SERVICES_GRACETIM=5000 \
#    S6_KILL_GRACETIME=5000 \
#    LANG=C.UTF-8 \
#    PS1="\u@\h:\w\\$ " \
#    RCLONE_CONFIG=/config/rclone.conf \
#    RCLONE_REFRESH_METHOD=default \
#    UFS_USER_OPTS="cow,direct_io,nonempty,auto_cache,sync_read" \
#    MFS_USER_OPTS="rw,use_ino,func.getattr=newest,category.action=all,category.create=ff,cache.files=auto-full,dropcacheonclose=true" \
#    DATE_FORMAT="+%4Y/%m/%d %H:%M:%S"
#
#VOLUME /config /cache /log /cloud /data /local
#WORKDIR /data
#
#HEALTHCHECK --interval=30s --timeout=30s --start-period=10s --retries=3 \
#    CMD /usr/local/bin/healthcheck
#
#ENTRYPOINT ["/init"]
