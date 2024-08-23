#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua.json
SOURCEMAP=darklua-sourcemap.json
SERVE_DIR=serve

rm -f $SOURCEMAP
rm -rf $SERVE_DIR
mkdir -p $SERVE_DIR

cp model.project.json $SERVE_DIR/model.project.json
cp build.project.json $SERVE_DIR/build.project.json
cp -r src $SERVE_DIR/src
cp -rL Packages $SERVE_DIR/Packages
cp -rL node_modules $SERVE_DIR/node_modules
rojo sourcemap model.project.json -o $SOURCEMAP
rojo sourcemap build.project.json --output sourcemap.json

rojo sourcemap --watch model.project.json -o $SOURCEMAP &
darklua process src $SERVE_DIR/src --config $DARKLUA_CONFIG -w & 

rojo serve $SERVE_DIR/build.project.json