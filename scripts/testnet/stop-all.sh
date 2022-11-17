#!/usr/bin/env bash
docker stop ightning-api lightningd
sleep 5
docker stop bitcoind
