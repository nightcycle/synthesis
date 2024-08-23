#!/usr/bin/env bash
wally install
rojo sourcemap build.project.json --output sourcemap.json
wally-package-types --sourcemap sourcemap.json Packages