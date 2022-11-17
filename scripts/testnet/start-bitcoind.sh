#!/usr/bin/env bash
docker run --name bitcoind-testnet -d --restart unless-stopped --network bitcoind-testnet --ip 10.0.0.2 -v $HOME/bitcoin-lightning-node/shares/testnet/dot-bitcoin:/.bitcoin
