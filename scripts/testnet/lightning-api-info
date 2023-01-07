#!/usr/bin/env bash
curl -X 'GET' 'http://localhost:33001/v1/getinfo' -H 'accept: application/json' -H "macaroon: $(xxd -ps -u -c 100 shares/testnet/lightning-api-certs/access.macaroon | tr '\n' '\0')" -H 'encodingtype: hex'
