# When changing this source repository, don't forget to also change the release repository for docker-ce-cli
FROM ubuntu:18.04

MAINTAINER Gremlin Inc. <support@gremlin.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y apt-transport-https ca-certificates gnupg-agent \
    && echo "deb https://deb.gremlin.com/ release non-free" > /etc/apt/sources.list.d/gremlin.list \
    && echo "deb https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
         # Docker
         7EA0A9C3F273FCD8 \
         # Gremlin
         9CDB294B29A5B1E2E00C24C022E8EF3461A50EF6 \
    && apt-get update \
    && apt-get install -y sudo dnsutils iproute2 docker-ce-cli lsb-core \
    # HACK to work around install scripts, we only need the binaries
    && apt-get install -y -d gremlin gremlind \
    && mkdir /tmp/gremlin \
    && dpkg -x /var/cache/apt/archives/gremlin_*.deb /tmp/gremlin \
    && dpkg -x /var/cache/apt/archives/gremlind_*.deb /tmp/gremlin \
    && cp -a /tmp/gremlin/usr/bin/gremlin /usr/bin/gremlin \
    && cp -a /tmp/gremlin/usr/sbin/gremlind /usr/sbin/ \
    && rm -rf /tmp/gremlin /var/cache/apt/archives/gremlin*.deb /var/lib/apt/lists/*

COPY entrypoints/main.sh /entrypoint.sh

EXPOSE 8080 8888
USER 1001

ENTRYPOINT ["/entrypoint.sh"]
