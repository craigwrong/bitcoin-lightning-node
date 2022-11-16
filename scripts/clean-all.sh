#!/usr/bin/env bash
docker rm -f lightning-api lightningd bitcoind
docker network rm bitcoind
