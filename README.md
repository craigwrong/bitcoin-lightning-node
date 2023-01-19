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


## Cross-Compiling from macOS (Apple Sillicon) to x86

To build images and run containers on an ARM-based Mac for x86 pass `--platform linux/amd64` to the docker command.

For better x86 emulation performance use `colima` which supports Rosetta 2 and Virtualization Framework (as opposed to Docker Desktop's use of QEMU). Make sure you install Rosetta as well.

    brew install colima --HEAD
    colima start --arch aarch64 --vm-type=vz --vz-rosetta  --cpu 4 --memory 8
    docker run --platform linux/amd64 --rm -it ubuntu
    # In the new shell
    uname -a
    # Linux e7c3cb1e6650 5.15.82-0-virt #1-Alpine SMP Mon, 12 Dec 2022 09:15:17 +0000 x86_64 x86_64 x86_64 GNU/Linux
    ps -fe
    # root         1     0  0 23:01 pts/0    00:00:00 /mnt/lima-rosetta/rosetta /usr/bin/bash


## Export / Import image

We can build the docker images on a workstation and then transfer them to the server.

    docker save bitcoind | gzip > bitcoind.tgz
    docker load -i bitcoind.tgz

When building on a different architecture/platform like an Apple Silicon Mac, make sure you pass the `--platform=linux/amd64` to the Docker commands if that's your target (i.e. server) system.

On ARM Macs we can use _Lima_ / _Colima_ and _Rossetta 2_ to emulate x86 efficiently and target said platform.
