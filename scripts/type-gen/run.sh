#!/usr/bin/env bash
source .env/Scripts/Activate
out_path="src/RobloxTypes.luau"
py scripts/type-gen/gen.py $out_path
stylua $out_path