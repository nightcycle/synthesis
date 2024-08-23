#!/usr/bin/env bash
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