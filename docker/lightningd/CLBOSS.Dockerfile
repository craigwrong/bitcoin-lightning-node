# syntax=docker/dockerfile:1
FROM ubuntu as base
ENV CORE_LIGHTNING_VERSION=v22.11.1
RUN \
    apt-get update && \
    apt-get --yes upgrade

#  docker build --platform linux/amd64 -f Dockerfile.build .
FROM base as prep
# Rusty Russell
ENV RUSTY_SIGNATURE=15EE8D6CAB0E7F0CF999BFCBD9200E6CD1ADB8F1
 # "Christian Decker <decker.christian@gmail.com>"
ENV CHRISTIAN_SIGNATURE=B7C4BE81184FC203D52C35C51416D83DC4F0E86D
ENV CHRISTIAN2_SIGNATURE=B731AAC521B013859313F674A26D6D9FE088ED58
 # Lisa Neigut
ENV LISA_SIGNATURE=30DE693AE0DE9E37B3E7EB6BBFF0F67810C1EED1
WORKDIR /opt
RUN \
    apt-get --yes install --no-install-recommends wget ca-certificates unzip gnupg && \
    wget -q https://github.com/ElementsProject/lightning/releases/download/$CORE_LIGHTNING_VERSION/clightning-$CORE_LIGHTNING_VERSION.zip && \
    wget -q https://github.com/ElementsProject/lightning/releases/download/$CORE_LIGHTNING_VERSION/SHA256SUMS && \
    wget -q https://github.com/ElementsProject/lightning/releases/download/$CORE_LIGHTNING_VERSION/SHA256SUMS.asc && \
    sha256sum --ignore-missing -c SHA256SUMS && \
    gpg --recv-keys $RUSTY_SIGNATURE $CHRISTIAN_SIGNATURE $CHRISTIAN2_SIGNATURE $LISA_SIGNATURE && \
    gpg --verify SHA256SUMS.asc SHA256SUMS && \
    rm SHA256SUMS.asc SHA256SUMS && \
    unzip clightning-$CORE_LIGHTNING_VERSION.zip && \
    rm clightning-$CORE_LIGHTNING_VERSION.zip

FROM base as builder
COPY --from=prep /opt/clightning-$CORE_LIGHTNING_VERSION /opt/clightning-$CORE_LIGHTNING_VERSION
WORKDIR /opt/clightning-$CORE_LIGHTNING_VERSION
RUN \
    apt-get --yes install --no-install-recommends autoconf automake build-essential libtool libgmp-dev libsqlite3-dev python3 python3-pip net-tools zlib1g-dev libsodium-dev gettext cargo rustfmt protobuf-compiler && \
    pip3 install --upgrade pip && \
    pip3 install mako && \
    LDFLAGS="-static-libstdc++" ./configure  --prefix=/opt/clightning-dist --enable-rust --enable-static && \
    make && \
    make install

FROM base as clboss-builder
WORKDIR /root
RUN \
    apt-get --yes install --no-install-recommends ca-certificates wget build-essential pkg-config libev-dev libcurl4-gnutls-dev libsqlite3-dev && \
    wget -qO- https://github.com/ZmnSCPxj/clboss/files/8596285/clboss-0.12.tar.gz | tar xzf - && \
    cd clboss-0.12 && \
    ./configure --prefix=/root && \
    make && \
    make install

FROM base as daemon
# Deps for CLBoss
RUN \
    apt-get --yes install --no-install-recommends dnsutils libev4 libcurl3-gnutls libsqlite3-0
COPY --from=builder /opt/clightning-dist /clightning
COPY --from=clboss-builder /root/bin/clboss /usr/bin/clboss
COPY --from=bitcoin-cli /bin/bitcoin-cli /usr/bin/bitcoin-cli
WORKDIR /clightning
COPY docker-entrypoint.sh /usr/bin/
VOLUME /root/.lightning
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]

FROM scratch as deps
COPY --from=base /lib/x86_64-linux-gnu/libpthread.so.0 /lib/libpthread.so.0
COPY --from=base /lib/x86_64-linux-gnu/libm.so.6 /lib/libm.so.6
COPY --from=base /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/libgcc_s.so.1
COPY --from=base /lib/x86_64-linux-gnu/libc.so.6 /lib/libc.so.6
#COPY --from=base /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
COPY --from=base /lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2

#COPY --from=base /lib/aarch64-linux-gnu/libpthread.so.0 /lib/libpthread.so.0
#COPY --from=base /lib/aarch64-linux-gnu/libm.so.6 /lib/libm.so.6
#COPY --from=base /lib/aarch64-linux-gnu/libgcc_s.so.1 /lib/libgcc_s.so.1
#COPY --from=base /lib/aarch64-linux-gnu/libc.so.6 /lib/libc.so.6
#COPY --from=base /lib/aarch64-linux-gnu/ld-linux-aarch64.so.1  /lib/ld-linux-aarch64.so.1
##COPY --from=base /lib/aarch64-linux-gnu/ld-2.31.so  /lib/ld-2.31.so

FROM scratch as daemon-lean
COPY --from=deps / /
COPY --from=builder /opt/clightning-dist/bin/lightningd /bin/lightningd
COPY --from=builder /opt/clightning-dist/libexec /libexec
COPY --from=clboss-builder /root/bin/clboss /bin/clboss
COPY --from=bitcoin-cli /bin/bitcoin-cli /bin/bitcoin-cli
VOLUME /.lightning
ENTRYPOINT ["/bin/lightningd"]

FROM scratch as cli
COPY --from=deps / /
COPY --from=builder /opt/clightning-dist/bin/lightning-cli /bin/lightning-cli
VOLUME /.lightning
ENTRYPOINT ["/bin/lightning-cli"]
