#! /bin/bash

goto_bookmark() {

	bookmark_name="$OPTARG"

	goto_cmd() {
		cd "$1" || exit
	}

	bookmark_file="$HOME/bin/bookmarks/bookmarks.txt"

	while read -r p; do
		bm_name=$(echo "$p" | cut -d ',' -f 1 | cut -d '[' -f 2)
		bm_location=$(echo "$p" | cut -d ',' -f 2 | cut -d ']' -f 1)

		if [ "$bm_name" = "$bookmark_name" ]; then
			goto_cmd "$bm_location"
		fi
	done <"$bookmark_file"
}
