# syntax=docker/dockerfile:1

FROM ubuntu AS base
ARG TARGETARCH
ENV BITCOIN_CORE_VERSION=28.0
# Pieter Wuille
ENV SIGNATURE1=133EAC179436F14A5CF1B794860FEB804E669320
 # Michael Ford
ENV SIGNATURE2=E777299FC265DD04793070EB944D35F9AC3DB76A
 # Andrew Chow
ENV SIGNATURE3=152812300785C96444D3334D17565732E08E5E41
WORKDIR /opt
RUN \
    apt-get update && \
    apt-get --yes upgrade && \
    apt-get --yes install --no-install-recommends wget ca-certificates gnupg && \
    if [  $TARGETARCH = arm64 ]; then export ARCH=aarch64; elif [ $TARGETARCH = amd64 ]; then export ARCH=x86_64; else export ARCH=$TARGETARCH; fi && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/bitcoin-$BITCOIN_CORE_VERSION-$ARCH-linux-gnu.tar.gz && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/SHA256SUMS && \
    wget -q https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_CORE_VERSION/SHA256SUMS.asc && \
    sha256sum --ignore-missing -c SHA256SUMS && \
    gpg --batch --quiet --keyserver keyserver.ubuntu.com --recv-keys $SIGNATURE1 $SIGNATURE2 $SIGNATURE3 && \
    gpg --status-fd 1 --verify SHA256SUMS.asc SHA256SUMS 2>/dev/null | grep -q "GOODSIG" || exit 1 && \
    rm SHA256SUMS.asc SHA256SUMS && \
    tar xfz bitcoin-$BITCOIN_CORE_VERSION-$ARCH-linux-gnu.tar.gz && \
    rm bitcoin-$BITCOIN_CORE_VERSION-$ARCH-linux-gnu.tar.gz && \
    mv bitcoin-$BITCOIN_CORE_VERSION bitcoin
VOLUME /root/.bitcoin

FROM base AS bitcoind
ENTRYPOINT ["/opt/bitcoin/bin/bitcoind"]

FROM base AS bitcoin-cli
ENTRYPOINT ["/opt/bitcoin/bin/bitcoin-cli"]
