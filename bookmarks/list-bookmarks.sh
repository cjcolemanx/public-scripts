#! /bin/bash
# This file needs to be sourced to be used!

list_bookmarks() {
	# Give some space to the output
	echo ""
	echo "+---------------+"
	echo "| Bookmark List |"
	echo "+---------------+"
	echo ""

	# Parse Command Line args
	while getopts "t:" opt; do
		case $opt in
		# default
		t)
			list_type="$OPTARG"
			break
			;;
		*)
			echo "Invalid option"
			break
			;;
		esac
	done

	bookmarks_file="$HOME/bin/bookmarks/bookmarks.txt"

	# Initialize arrays to display single info
	bookmark_names=()
	bookmark_locations=()

	# Initialize array to display table
	table_col_seperator=" --> "
	first_table_entry=$(printf "%-15b %b %-20b" "'Bookmark Name'" " ... " "'Bookmark Location'")
	bookmark_table=("$first_table_entry")

	# Get all bookmarks
	while read -r p; do
		# Grab info
		bm_name=$(echo "$p" | cut -d ',' -f 1 | cut -d '[' -f 2)
		bm_location=$(echo "$p" | cut -d ',' -f 2 | cut -d ']' -f 1)

		# Get rid of expanded HOME
		if [[ "$bm_location" == *"$HOME"* ]]; then
			home_string_substitute="~"
			bm_location="${bm_location/"$HOME"/"$home_string_substitute"}"
		fi

		# Set up arrays
		bookmark_names+=("$bm_name")
		bookmark_locations+=("$bm_location")

		# Make table to display all
		table_entry=$(printf "%-15b %b %-20b" "$bm_name" "$table_col_seperator" "$bm_location")
		bookmark_table+=("$table_entry")
	done <"$bookmarks_file"

	# Print the bookmark names and locations
	if [ "$list_type" = "all" ]; then
		echo "All Entries"
		echo ""

		index=1
		while [ $index -le "${#bookmark_table[*]}" ]; do
			echo "${bookmark_table[$index]}"
			((index++))
		done

		# Or, just the names
	elif [ "$list_type" = "bookmark_names" ]; then
		echo "Bookmark Names"
		echo ""

		for entry in "${bookmark_names[@]}"; do
			echo "$entry"
		done

		# Or, just the locations
	elif [ "$list_type" = "bookmark_locations" ]; then
		echo "Bookmarked Locations"
		echo ""

		for entry in "${bookmark_locations[@]}"; do
			echo "$entry"
		done
	fi
}
