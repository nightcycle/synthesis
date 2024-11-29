#!/bin/sh
set -e
ROJO_CONFIG=$1
sh scripts/download-types.sh
sh scripts/build.sh "$ROJO_CONFIG"
cd "build"

# make a temp file
lsp_results=$(mktemp)

set +e

luau-lsp analyze \
	--sourcemap="sourcemap.json" \
	--ignore="**/node_modules/**" \
	--ignore="node_modules/**" \
	--ignore="**/Packages/**" \
	--ignore="Packages/**" \
	--ignore="**/external/**" \
	--ignore="external/**" \
	--ignore="*.test.luau" \
	--ignore="*.lune.luau" \
	--settings=".luau-analyze.json" \
	--definitions="types/globalTypes.d.lua" \
	"src" 2> "$lsp_results"
set -e

# iterate through the results
is_error=false
while IFS= read -r line; do
	# if the line is empty, skip it
	if [ -z "$line" ]; then
		continue
	fi

	# create a variable called path_line which is the line up until the first "(" or "["
	path_line=$(echo "$line" | cut -d "(" -f 1)

	# create a variable called min_path_line which is the line up to the first whitespace character
	min_path_line=$(echo "$path_line" | cut -d " " -f 1)

	echo ""

	# get the contents of the first two colons in line
	error_type=$(echo "$line" | sed -n 's/.*:\([^:]*\):.*/\1/p')

	# remove whitespace from error_type
	error_type=$(echo "$error_type" | tr -d '[:space:]')

	# get the contents after the second colon in line
	error_message=$(echo "$line" | sed -n 's/.*:.*: \(.*\)/\1/p')

	echo -e "\e[31merror[$error_type]\e[0m: \"$error_message\""

	# get the contents of the first parentheses pair in line
	line_numbers=$(echo "$line" | sed -n 's/.*(\([^)]*\)).*/\1/p')

	echo "    $min_path_line:($line_numbers)"

done < "$lsp_results"

echo ""
selene src

if [ "$is_error" = true ]; then
	exit 1
fi