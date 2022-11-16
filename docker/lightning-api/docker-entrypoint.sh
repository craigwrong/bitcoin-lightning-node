#!/bin/sh
set -e

cat <<-EOF > "cl-rest-config.json"
{
    "PORT": $PORT,
    "DOCPORT": $DOCPORT,
    "PROTOCOL": "$PROTOCOL",
    "EXECMODE": "$EXECMODE",
    "RPCCOMMANDS": "$RPCCOMMANDS"
}
EOF

sleep 10

exec node cl-rest.js
