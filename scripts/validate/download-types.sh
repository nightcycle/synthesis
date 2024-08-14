#!/usr/bin/env bash

# type definitions
if [ ! -d "types" ]; then
  mkdir "types"
fi
curl -L "https://gist.github.com/nightcycle/50ca8f42147077b8f584b503030c8500/raw" > "types/testEZ.d.lua"
curl -L "https://gist.github.com/nightcycle/ae7ea3376337512772d1d2b314ef467b/raw" > "types/remodel.d.lua"
curl -L "https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua" > "types/globalTypes.d.lua"

# lint definitions
if [ ! -d "lints" ]; then
  mkdir "lints"
fi
curl -L "https://gist.github.com/nightcycle/a57e04de443dfa89bd08c8eb001b03c6/raw" > "lints/lua51.yml"
curl -L "https://gist.github.com/nightcycle/93c4b9af5bbf4ed09f39aa908dffccd0/raw" > "lints/luau.yml"
