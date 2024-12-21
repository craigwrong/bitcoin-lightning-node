# syntax=docker/dockerfile:1

FROM elementsproject/lightningd:v24.11.1 as base
RUN \
    apt-get update && \
    apt-get --yes upgrade && \
    apt-get --yes install --no-install-recommends git python3-venv python3-json5 python3-flask python3-gunicorn && \
    pip3 install --user flask-cors flask-restx pyln-client flask-socketio gevent gevent-websocket && \
    mkdir /root/.lightning/bitcoin && \
    touch /root/.lightning/bitcoin/config && \
    reckless -d /root/reckless install feeadjuster && \
    reckless -d /root/reckless install book && \
    rm -rf /root/.lightning/bitcoin && \
    apt-get --yes remove git && \
    apt --yes autoremove

FROM base as lightningd
COPY docker-entrypoint.sh /usr/local/bin/
VOLUME /root/.lightning
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

FROM base as lightning-cli
VOLUME /root/.lightning
ENTRYPOINT ["/usr/local/bin/lightning-cli"]
