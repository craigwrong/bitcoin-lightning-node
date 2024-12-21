# syntax=docker/dockerfile:1

ARG BASE_DISTRO="node:alpine"

FROM --platform=${BUILDPLATFORM} ${BASE_DISTRO} AS builder
ENV RTL_VERSION=0.15.4
ENV SIGNATURE1=suheb
WORKDIR /opt
RUN \
    apk update && \
    apk upgrade && \
    apk add --no-cache gnupg && \
    wget -q https://github.com/Ride-The-Lightning/RTL/archive/refs/tags/v$RTL_VERSION.tar.gz && \
    wget -q https://github.com/Ride-The-Lightning/RTL/releases/download/v$RTL_VERSION/v$RTL_VERSION.tar.gz.asc && \
    wget -O - https://keybase.io/$SIGNATURE1/pgp_keys.asc | gpg --import && \
    gpg --status-fd 1 --verify v$RTL_VERSION.tar.gz.asc v$RTL_VERSION.tar.gz 2>/dev/null | grep -q "GOODSIG" || exit 1 && \
    rm v$RTL_VERSION.tar.gz.asc && \
    tar xfz v$RTL_VERSION.tar.gz && \
    rm v$RTL_VERSION.tar.gz && \
    mv RTL-$RTL_VERSION rtl && \
    cd rtl && \
    npm install --legacy-peer-deps && \
    NG_CLI_ANALYTICS=false npm run buildfrontend && \
    npm run buildbackend && \
    npm prune --omit=dev --legacy-peer-deps

FROM --platform=${TARGETPLATFORM} ${BASE_DISTRO} AS runner
RUN \
    apk update && \
    apk upgrade && \
    apk add --no-cache tini
WORKDIR /opt/rtl
COPY --from=builder /opt/rtl/rtl.js ./rtl.js
COPY --from=builder /opt/rtl/package.json ./package.json
COPY --from=builder /opt/rtl/frontend ./frontend
COPY --from=builder /opt/rtl/backend ./backend
COPY --from=builder /opt/rtl/node_modules/ ./node_modules
ENV RTL_CONFIG_PATH /root/rtl
EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "-g", "--"]
CMD ["node", "rtl"]
