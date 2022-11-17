# syntax=docker/dockerfile:1
FROM debian as clboss-builder
RUN apt-get update && apt-get -y upgrade && apt-get -y install --no-install-recommends ca-certificates wget build-essential pkg-config libev-dev libcurl4-gnutls-dev libsqlite3-dev
WORKDIR /root
RUN \
    wget -qO- https://github.com/ZmnSCPxj/clboss/files/8596285/clboss-0.12.tar.gz | tar xzf - && \
    cd clboss-0.12 && \
    ./configure --prefix=/root && \
    make && \
    make install

FROM ubuntu
COPY --from=bitcoin-cli /bin/bitcoin-cli /usr/local/bin/bitcoin-cli
RUN \
    apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive TZ="Europe/Lisbon" apt-get install -y --no-install-recommends tzdata dnsutils libev4 libcurl3-gnutls libsqlite3-0 && \
    apt-get install -y --no-install-recommends gpg-agent software-properties-common && \
    add-apt-repository -y -u ppa:lightningnetwork/ppa && \
        apt-get -y install --no-install-recommends lightningd
COPY --from=clboss-builder /root/bin/clboss /usr/bin/clboss
COPY docker-entrypoint.sh /root/bin/
VOLUME /root/.lightning
ENTRYPOINT ["/root/bin/docker-entrypoint.sh"]
