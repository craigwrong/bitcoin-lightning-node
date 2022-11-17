#!/usr/bin/env bash
docker run --name lightning-api-testnet -d --restart unless-stopped -e PROTOCOL=http -e PORT=33001 -e DOCPORT=44001 -p 33001:33001 -p 44001:44001 -v $HOME/bitcoin-lightning-node/shares/testnet/dot-lightning:/root/.lightning -v $HOME/bitcoin-lightning-node/shares/testnet/lightning-api-certs:/usr/src/app/certs lightning-api
