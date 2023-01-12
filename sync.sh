#! /bin/bash

SCRIPT_DIR="$HOME/bin/"

scripts_to_copy=(
	## BOOKMARKS SCRIPT
	"bookmarks.sh"
	"bookmarks/add-bookmark.sh"
	"bookmarks/get-bookmarks.sh"
	"bookmarks/list-bookmarks.sh"
	"bookmarks/goto-bookmark.sh"
	"bookmarks/remove-bookmark.sh"
	"files/touch-nested.sh"
)

for i in "${scripts_to_copy[@]}"; do
	file_root_dir="$(dirname "$i")"
	# Check Directory Existence (mostly for new scripts)
	if [ -d ./"$file_root_dir" ]; then
		echo
	else
		echo Creating "$file_root_dir"
		mkdir -p ./"$file_root_dir"
	fi

	# Remove File
	rm ./"$i"

	echo Grabbing "$i"

	# Grab from folder, put in directory
	cp -r "$SCRIPT_DIR"/"$i" ./"$file_root_dir"
done
