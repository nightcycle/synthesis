#!/bin/sh
# iterate through every descendant of "scripts" directory with a ".sh" extension and echo the path
for file in $(find "scripts" -type f); do
	if [[ $file == *".sh" ]]; then
		tr -d '\r' < "$file" > "temp.sh"
		mv "temp.sh" "$file"
		echo "fixed $file"
	fi
done