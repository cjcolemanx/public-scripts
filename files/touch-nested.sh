#! /bin/bash

touch+() {
	cur_dir=$(pwd)
	file_to_create="$(basename "$1")"
	folders_to_create="$(dirname "$1")"

	mkdir -p "$folders_to_create"
	# Shouldn't error, but just in case
	cd "$folders_to_create" || exit
	touch "$file_to_create"
	# Same as above
	cd "$cur_dir" || exit
}
