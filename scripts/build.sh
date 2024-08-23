#!/bin/sh

set -e

DARKLUA_CONFIG=.darklua.json
SOURCEMAP=darklua-sourcemap.json
BUILD_DIR="build"
LSP_SETTINGS=".luau-analyze.json"

rm -f $SOURCEMAP
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

cp model.project.json $BUILD_DIR/model.project.json
cp build.project.json $BUILD_DIR/build.project.json
cp -r src $BUILD_DIR/src
cp -r types "$BUILD_DIR/types"
cp -r lints "$BUILD_DIR/lints"
cp -r selene.toml "$BUILD_DIR/selene.toml"
cp -r stylua.toml "$BUILD_DIR/stylua.toml"
cp -r "$LSP_SETTINGS" "$BUILD_DIR/$LSP_SETTINGS"
cp -rL Packages $BUILD_DIR/Packages
cp -rL wally.toml $BUILD_DIR/wally.toml
rojo sourcemap model.project.json -o $SOURCEMAP
rojo sourcemap build.project.json --output sourcemap.json
rojo sourcemap "$BUILD_DIR/build.project.json" -o "$BUILD_DIR/sourcemap.json"
darklua process src $BUILD_DIR/src --config $DARKLUA_CONFIG
stylua "$BUILD_DIR/src"