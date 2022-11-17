#!/usr/bin/env bash
docker run --name lightningd-testnet -d --restart unless-stopped --network bitcoind-testnet --ip 10.0.0.3 -v $HOME/bitcoin-lightning-node/shares/testnet/dot-lightning:/root/.lightning -v $HOME/bitcoin-lightning-node/shares/testnet/ln-backup:/ln-backup -v $HOME/bitcoin-lightning-node/shares/testnet/dot-bitcoin/testnet3:/root/.bitcoin/testnet3:ro lightningd
