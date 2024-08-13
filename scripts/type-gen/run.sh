#!/usr/bin/env bash
source .env/Scripts/Activate
py scripts/type-gen/gen.py $1
stylua $1