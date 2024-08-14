#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua.json
SOURCEMAP=sourcemap.json
SERVE_DIR=serve

rm -f $SOURCEMAP
rm -rf $SERVE_DIR
mkdir -p $SERVE_DIR

cp dev.project.json $SERVE_DIR/dev.project.json
cp -r src $SERVE_DIR/src
cp -rL node_modules $SERVE_DIR/node_modules

rojo sourcemap --watch dev.project.json -o $SOURCEMAP &
darklua process -w --config $DARKLUA_CONFIG src $SERVE_DIR/src &
darklua process -w --config $DARKLUA_CONFIG node_modules $SERVE_DIR/node_modules &

rojo serve $SERVE_DIR/dev.project.json