#!/usr/bin/env bash
docker run --name lightningd -d --restart unless-stopped --network bitcoind --ip 10.1.0.3 -p 9735:9735 -v $HOME/bitcoin-lightning-node/shares/dot-lightning:/root/.lightning -v /media/ln-backup:/ln-backup -v /TIMECHAIN:/root/.bitcoin:ro lightningd
