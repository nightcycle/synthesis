#!/bin/sh
set -e
BUILD_DIR="build"
if [ -d "$BUILD_DIR" ]; then
	rm -rf "$BUILD_DIR"
fi