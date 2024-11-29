#!/bin/sh
set -e
DARKLUA_CONFIG=".darklua.json"
ROJO_CONFIG="build.project.json"
MODEL_CONFIG="model.project.json"
BUILD_DIR="build"
LSP_SETTINGS=".luau-analyze.json"
BUILD_FILE="synthetic-dev.rbxl"
is_serve=false
for arg in "$@"
do
	if [ "$arg" = "--serve" ]; then
		is_serve=true
	fi
done

if [ "$is_serve" = true ]; then
	BUILD_DIR="serve"
fi

echo "removing $BUILD_DIR"
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
mkdir -p "$BUILD_DIR/scripts"

echo "copying contents to $BUILD_DIR"
cp -r "$MODEL_CONFIG" "$BUILD_DIR/$MODEL_CONFIG"
cp -r "$ROJO_CONFIG" "$BUILD_DIR/$ROJO_CONFIG"
cp -r src "$BUILD_DIR/src"
cp -rL Packages "$BUILD_DIR/Packages"
cp -r types "$BUILD_DIR/types"
cp -r lints "$BUILD_DIR/lints"
cp -r "$LSP_SETTINGS" "$BUILD_DIR/$LSP_SETTINGS"
cp -r "$DARKLUA_CONFIG" "$BUILD_DIR/$DARKLUA_CONFIG"
cp -r selene.toml "$BUILD_DIR/selene.toml"
cp -r stylua.toml "$BUILD_DIR/stylua.toml"

echo "building sourcemap at $BUILD_DIR/sourcemap.json"
rojo sourcemap "$BUILD_DIR/$ROJO_CONFIG" -o "$BUILD_DIR/sourcemap.json"

echo "building main sourcemap at sourcemap.json"
rojo sourcemap "$ROJO_CONFIG" -o "sourcemap.json"

echo "processing $BUILD_DIR/src with darklua"
darklua process src "$BUILD_DIR/src" --config "$DARKLUA_CONFIG"

echo "running stylua"
stylua "$BUILD_DIR/src"
rojo sourcemap "$BUILD_DIR/$ROJO_CONFIG" -o "$BUILD_DIR/sourcemap.json"

echo "processing $BUILD_DIR/src with darklua"
darklua process "src" "$BUILD_DIR/src" --config "$DARKLUA_CONFIG"
cd "$BUILD_DIR"
rojo build --output "$BUILD_FILE" "$ROJO_CONFIG"
cd ..
cp -r "$BUILD_DIR/$BUILD_FILE" "$BUILD_FILE"
if [ "$is_serve" = true ]; then
	rojo sourcemap --watch "$ROJO_CONFIG" -o "sourcemap.json" &
	darklua process "src" "$BUILD_DIR/src/Client" --config "$DARKLUA_CONFIG" -w &
	rojo serve "$BUILD_DIR/$ROJO_CONFIG"
fi

