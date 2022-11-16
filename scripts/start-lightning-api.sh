#!/usr/bin/env bash
docker run --name lightning-api -d --restart unless-stopped -e PROTOCOL=http -p 3001:3001 -p 4001:4001 -v $HOME/bitcoin-lightning-node/shares/dot-lightning:/root/.lightning -v $HOME/bitcoin-lightning-node/shares/lightning-api-certs:/usr/src/app/certs lightning-api
