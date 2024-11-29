#!/bin/sh
set -e
# type definitions
if [ ! -d "types" ]; then
  mkdir "types"
fi
curl -L "https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua" > "types/globalTypes.d.lua"
curl -L "https://gist.githubusercontent.com/nightcycle/3ecee1b598c4e1d26acd7a2899ff4350/raw/dec85b24dec6697e0c4f9fe9b991fd2d9f7efa21/bench.d.lua" > "types/benchmark.d.lua"

# lint definitions
if [ ! -d "lints" ]; then
  mkdir "lints"
fi
curl -L "https://gist.githubusercontent.com/nightcycle/a57e04de443dfa89bd08c8eb001b03c6/raw/50947035db00c1e9bd987994dc8818ac7076ef38/lua51.yml" > "lints/lua51.yml"
curl -L "https://gist.githubusercontent.com/nightcycle/93c4b9af5bbf4ed09f39aa908dffccd0/raw/dee11ac2eda462f5bf487a512aa35dee334bd2aa/luau.yml" > "lints/luau.yml"
