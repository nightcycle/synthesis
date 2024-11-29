#!/bin/sh
is_serve=false
for arg in "$@"
do
	if [ "$arg" = "--serve" ]; then
		is_serve=true
	fi
done

aftman install
set -e

lune setup

sh scripts/download-types.sh
if [ "$is_serve" = true ]; then
	sh scripts/build.sh --serve
else
	sh scripts/build.sh
fi
