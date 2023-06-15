# syntax=docker/dockerfile:1
FROM node:20-alpine
ENV VERSION=0.10.3
WORKDIR /root
ADD https://github.com/Ride-The-Lightning/c-lightning-REST/archive/refs/tags/v$VERSION.tar.gz /root/
RUN \
    apk add --update openssl tini && \
    rm -rf /var/cache/apk/* && \
    tar -xvf v$VERSION.tar.gz && \
    mv c-lightning-REST-$VERSION c-lightning-REST

WORKDIR /root/c-lightning-REST
RUN npm install --omit=dev

ENV PORT 3001
ENV DOCPORT 4001
ENV PROTOCOL https
ENV EXECMODE production

EXPOSE 3001
EXPOSE 4001

COPY docker-entrypoint.sh /root/c-lightning-REST/
ENTRYPOINT ["/sbin/tini", "-g", "--", "/root/c-lightning-REST/docker-entrypoint.sh"]
