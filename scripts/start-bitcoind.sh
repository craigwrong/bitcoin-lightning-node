#!/usr/bin/env bash
docker run --name bitcoind -d --restart unless-stopped --network bitcoind --ip 10.1.0.2 -v $HOME/bitcoin-lightning-node/shares/dot-bitcoin:/.bitcoin -v /TIMECHAIN:/TIMECHAIN bitcoind
