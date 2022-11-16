#!/usr/bin/env bash
docker run --rm --network bitcoind -v /TIMECHAIN/.cookie:/.bitcoin/.cookie bitcoin-cli -rpcconnect=10.1.0.2 -getinfo
