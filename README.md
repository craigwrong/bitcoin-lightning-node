# Bitcoin and Lightning Network Node

Configuration for running a Bitcoin and Lightning Network node on a single machine.

## Features

- Bitcoin Core
- C-Lightning
- CLBoss C-Lightning plugin
- c-lightning-REST Lightning API

## Getting started

To setup your node:

```sh
git clone https://github.com/craigwrong/bitcoin-lightning-node
cd bitcoin-lightning-node
scripts/build-bitcoind
scripts/build-bitcoin-cli
scripts/build-lightningd
scripts/build-lightning-api
scripts/setup-docker
scripts/start-bitcoind
scripts/bitcoin-info
scripts/start-lightningd
scripts/lightning-info
scripts/start-lightning-api
scripts/lightning-api-info
```

To stop and cleanup:

    scripts/stop-all
    scripts/clean-all

## Testnet

There is a `scripts/testnet` subfolder for commands that differ from their mainnet version. Test containers will read and write at `/shares/testnet` subfolders.

```sh
scripts/testnet/setup-docker
scripts/testnet/start-bitcoind
scripts/testnet/bitcoin-info
scripts/testnet/start-lightningd
scripts/testnet/lightning-info
scripts/testnet/start-lightning-api
scripts/testnet/lightning-api-info
```

To stop and cleanup:

    scripts/testnet/stop-all
    scripts/testnet/clean-all
