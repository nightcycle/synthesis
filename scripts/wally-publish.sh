#!/usr/bin/env bash
set -e
sh scripts/build.sh
rm -rf build/model.project.json
rm -rf build/build.project.json
cp -r default.project.json build/default.project.json
cd "build"
wally publish