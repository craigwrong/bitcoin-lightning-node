#!/usr/bin/env bash
set -e
sleep 5
source ./.venv/bin/activate
exec ./bin/lightningd "$@"
