#!/usr/bin/env bash
set -e
sh scripts/build.sh
cd "build"
wally publish