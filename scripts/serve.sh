#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua.json
SOURCEMAP=darklua-sourcemap.json
SERVE_DIR=serve

rm -f $SOURCEMAP
rm -rf $SERVE_DIR
mkdir -p $SERVE_DIR

cp model.project.json $SERVE_DIR/model.project.json
cp serve.project.json $SERVE_DIR/serve.project.json
cp -r src $SERVE_DIR/src
cp -rL Packages $SERVE_DIR/Packages

rojo sourcemap model.project.json -o $SOURCEMAP

rojo sourcemap --watch model.project.json -o $SOURCEMAP &
darklua process src $SERVE_DIR/src --config $DARKLUA_CONFIG -w & 

rojo serve $SERVE_DIR/serve.project.json