#!/usr/bin/env bash
set -e
sh scripts/download-types.sh
sh scripts/build.sh
cd "build"
luau-lsp analyze \
	--sourcemap="sourcemap.json" \
	--ignore="**/Packages/**" \
	--ignore="Packages/**" \
	--ignore="*.spec.luau" \
	--settings=".luau-analyze.json" \
	--definitions="types/globalTypes.d.lua" \
	"src"
selene src