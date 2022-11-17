#!/usr/bin/env bash
docker run --rm --network bitcoind-testnet -v $HOME/bitcoin-lightning-node/shares/testnet/dot-bitcoin/testnet3/.cookie:/.bitcoin/testnet3/.cookie bitcoin-cli -testnet -rpcconnect=10.0.0.2 -getinfo
