# syntax=docker/dockerfile:1

FROM debian as base
RUN \
    apt-get update && \
    apt-get --yes upgrade

FROM base as prep
ENV BITCOIN_CORE_VERSION=25.0
# Pieter Wuille
ENV SIGNATURE1=133EAC179436F14A5CF1B794860FEB804E669320
 # Michael Ford
ENV SIGNATURE2=E777299FC265DD04793070EB944D35F9AC3DB76A
 # Andrew Chow
ENV SIGNATURE3=152812300785C96444D3334D17565732E08E5E41
WORKDIR /opt
RUN \
    apt-get --yes install --no-install-recommends wget ca-certificates unzip gnupg autoconf automake pkg-config libtool && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/bitcoin-$BITCOIN_CORE_VERSION.tar.gz && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/SHA256SUMS && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/SHA256SUMS.asc && \
    sha256sum --ignore-missing -c SHA256SUMS && \
    gpg --recv-keys $SIGNATURE1 $SIGNATURE2 $SIGNATURE3 && \
    gpg --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null | grep -q "GOODSIG" || exit 1 && \
    rm SHA256SUMS.asc SHA256SUMS && \
    tar xfz bitcoin-$BITCOIN_CORE_VERSION.tar.gz && \
    rm bitcoin-$BITCOIN_CORE_VERSION.tar.gz && \
    mv bitcoin-$BITCOIN_CORE_VERSION bitcoin && \
    cd bitcoin && \
    ./autogen.sh

FROM base as builder-base
RUN apt-get --yes install --no-install-recommends make g++ binutils

FROM builder-base as builder-depends
COPY --from=prep /opt/bitcoin /opt/bitcoin
RUN apt-get --yes install --no-install-recommends curl ca-certificates lbzip2
WORKDIR /opt/bitcoin/depends
RUN make NO_QT=1 NO_QR=1 NO_ZMQ=1 NO_WALLET=1 NO_BDB=1 NO_SQLITE=1 NO_UPNP=1 NO_NATPMP=1 NO_USDT=1

FROM builder-base as builder
COPY --from=prep /opt/bitcoin /opt/bitcoin
COPY --from=builder-depends /opt/bitcoin/depends/x86_64-pc-linux-gnu /opt/bitcoin/depends
# COPY --from=builder-depends /opt/bitcoin/depends/aarch64-unknown-linux-gnu /opt/bitcoin/depends
RUN apt-get --yes install --no-install-recommends pkg-config
WORKDIR /opt/bitcoin
RUN LDFLAGS="-static-libstdc++" ./configure \
        --prefix=`pwd`/depends \
        --without-wallet --without-sqlite --without-bdb --without-gui --without-libs \
        --disable-tests --disable-bench --disable-external-signer \
        --enable-daemon --enable-util-cli --disable-util-tx --disable-util-wallet --disable-util-util && \
    make install

FROM scratch as deps
COPY --from=debian /lib/x86_64-linux-gnu/libpthread.so.0 /lib/libpthread.so.0
COPY --from=debian /lib/x86_64-linux-gnu/libm.so.6 /lib/libm.so.6
COPY --from=debian /lib/x86_64-linux-gnu/libgcc_s.so.1 /lib/libgcc_s.so.1
COPY --from=debian /lib/x86_64-linux-gnu/libc.so.6 /lib/libc.so.6
COPY --from=debian /lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2
# COPY --from=debian /lib/aarch64-linux-gnu/libpthread.so.0 /lib/libpthread.so.0
# COPY --from=debian /lib/aarch64-linux-gnu/libm.so.6 /lib/libm.so.6
# COPY --from=debian /lib/aarch64-linux-gnu/libgcc_s.so.1 /lib/libgcc_s.so.1
# COPY --from=debian /lib/aarch64-linux-gnu/libc.so.6 /lib/libc.so.6
# COPY --from=debian /lib/aarch64-linux-gnu/ld-linux-aarch64.so.1  /lib/ld-linux-aarch64.so.1
# COPY --from=debian /lib/aarch64-linux-gnu/ld-2.31.so  /lib/ld-2.31.so

FROM scratch as daemon
COPY --from=deps / /
COPY --from=builder /opt/bitcoin/depends/bin/bitcoind /bin/bitcoind
VOLUME /.bitcoin
ENTRYPOINT ["/bin/bitcoind"]

FROM scratch as cli
COPY --from=deps / /
COPY --from=builder /opt/bitcoin/depends/bin/bitcoin-cli /bin/bitcoin-cli
VOLUME /.bitcoin
ENTRYPOINT ["/bin/bitcoin-cli"]
