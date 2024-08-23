#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua.json
SOURCEMAP=darklua-sourcemap.json
BUILD_DIR="build"

rm -f $SOURCEMAP
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

cp model.project.json $BUILD_DIR/model.project.json
cp serve.project.json $BUILD_DIR/serve.project.json
cp -r src $BUILD_DIR/src
cp -rL Packages $BUILD_DIR/Packages
cp -rL node_modules $BUILD_DIR/node_modules
rojo sourcemap model.project.json -o $SOURCEMAP
rojo sourcemap serve.project.json --output sourcemap.json
darklua process src $BUILD_DIR/src --config $DARKLUA_CONFIG