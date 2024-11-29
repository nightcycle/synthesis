#!/bin/sh
set -e
ROJO_CONFIG=$1
wally install
echo "building sourcemap at sourcemap.json with config $ROJO_CONFIG"
rojo sourcemap "$ROJO_CONFIG" --output sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages