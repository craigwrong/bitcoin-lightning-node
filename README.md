# Bitcoin and Lightning Network Node

Configuration for running a Bitcoin and Lightning Network node on a single machine.

## Features

- Bitcoin Core
- Core Lightning with CLNREST and other reckless plugins
- Ride The Lightning web application

## Getting started

To setup your node:

```sh
git clone https://github.com/craigwrong/bitcoin-lightning-node
cd bitcoin-lightning-node
scripts/build-bitcoind
scripts/build-bitcoin-cli
scripts/build-lightningd
scripts/setup-docker
scripts/bitcoind
scripts/bitcoin-cli
scripts/lightningd
scripts/lightning-cli getinfo
scripts/lightning-api
```

To stop and cleanup:

    scripts/stop-all
    scripts/clean-all

## Testnet

There is a `scripts/testnet` subfolder for commands that differ from their mainnet version. Test containers will read and write at `/shares/testnet` subfolders.

```sh
scripts/testnet/setup-docker
scripts/testnet/bitcoind
scripts/testnet/bitcoin-cli
scripts/testnet/lightningd
scripts/testnet/lightning-cli getinfo
scripts/testnet/lightning-api
scripts/testnet/rtl-app
```

To stop and cleanup:

    scripts/testnet/stop-all
    scripts/testnet/clean-all


## Cross-Compiling from macOS (Apple Silcon) to x86

To build images and run containers on an ARM-based Mac for x86 pass `--platform linux/amd64` to the docker command.

    docker build --platform linux/arm64,linux/amd64 --target bitcoind -t bitcoind ./docker/bitcoind
    docker build --platform linux/arm64,linux/amd64 --target bitcoin-cli -t bitcoin-cli ./docker/bitcoind
    docker build --platform linux/arm64,linux/amd64 --target lightningd -t lightningd ./docker/lightningd
    docker build --platform linux/arm64,linux/amd64 --target lightning-cli -t lightning-cli ./docker/lightningd
    docker build --platform linux/arm64,linux/amd64 -t rtl-app ./docker/rtl-app
    docker image ls --tree


### Colima

For alternative x86 emulation performance use `colima` which supports Rosetta 2 and Virtualization Framework (as opposed to Docker Desktop's use of QEMU). Make sure you install Rosetta as well.

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

Or if you want a single platform from a multi-platform archive:

    docker import --platform linux/amd64 bitcoind.tgz

Unfortunately there's been some issues with this technique so we are stuck with building for target platform only and using save/load docker commands. You may use a different image name if you have some containers running locally.

When building on a different architecture/platform like an Apple Silicon Mac, make sure you pass the `--platform=linux/amd64` to the Docker commands if that's your target (i.e. server) system.

### ARM -> x86

To save all images and move them to another machine:

    docker save bitcoind | gzip > bitcoind.tgz
    docker save bitcoin-cli | gzip > bitcoin-cli.tgz
    docker save lightningd | gzip > lightningd.tgz   
    docker save lightning-cli | gzip > lightning-cli.tgz 
    docker save rtl-app | gzip > rtl-app.tgz   

    scp *.tgz toximaxi:/home/satoshi

On ARM Macs we can use _Lima_ / _Colima_ and _Rosetta 2_ to emulate x86 efficiently and target said platform.
