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
scripts/setup-docker
scripts/build-bitcoind
scripts/build-bitcoin-cli
scripts/build-lightningd
scripts/build-lightning-api
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
