#! /bin/bash

remove_bookmark() {
	# Give some space to the output
	echo ""
	echo "+------------------+"
	echo "| Bookmark Removal |"
	echo "+------------------+"
	echo ""

	target_to_remove=""

	# Initialize arrays to fill
	bookmark_options=()
	local -A bookmark_locations=()

	# Parse Command Line args
	while getopts "B:" opt; do
		case $opt in
		B)
			target_to_remove="$OPTARG"
			break
			;;
		*)
			echo "Please provide a bookmark name with the '-a' flag"
			break
			;;
		esac
	done

	# Make sure bookmark file exists
	if [ -f "$HOME/bin/bookmarks/bookmarks.txt" ]; then
		bookmarks_file="$HOME/bin/bookmarks/bookmarks.txt"
	else
		# Nothing to remove!
		echo "There are no bookmarks to remove!"
		return
	fi

	# Build temp file
	if [ -f "$HOME/bin/bookmarks/~bookmarks.txt" ]; then
		temp_bookmarks_file="$HOME/bin/bookmarks/~bookmarks.txt"
	else
		touch "$temp_bookmarks_file"
		temp_bookmarks_file="$HOME/bin/bookmarks/~bookmarks.txt"
	fi

	# Get Options from file
	while read -r p; do
		# Parse Name and location
		bm_name=$(echo "$p" | cut -d ',' -f 1 | cut -d '[' -f 2)
		bm_location=$(echo "$p" | cut -d ',' -f 2 | cut -d ']' -f 1)

		# Put in Arrays
		bookmark_options+=("$bm_name")
		bookmark_locations+=(["$bm_name"]="$bm_location")
	done <"$bookmarks_file"

	# Used in `check_bookmark_existence`
	valid_bookmark=0

	# Iterate over options to make sure the target exists
	check_bookmark_existence() {
		for bm in "${bookmark_options[@]}"; do
			if [ "$bm" = "$target_to_remove" ]; then
				valid_bookmark=1
			fi
		done
	}

	# Save
	save_bookmark_changes() {
		# Reset Bookmarks
		: >"$bookmarks_file"

		# Duplicate temp file contents to bookmark contents
		while read -r p; do
			echo "$p" >>"$bookmarks_file"
		done <"$temp_bookmarks_file"

		# Reset Temp File
		: >"$temp_bookmarks_file"
	}

	# Prints entry to temp file
	save_new_entry_to_temp_file() {
		echo "[$1,$2]" >>"$temp_bookmarks_file"
	}

	# Empties file and rebuilds
	delete_bookmark_from_file() {
		echo ""

		# Prepare Temp File
		: >"$temp_bookmarks_file"

		for entry in "${bookmark_options[@]}"; do
			if [ "$entry" != "$target_to_remove" ] && [ "$entry" != "Quit" ] && [ -n "$entry" ]; then
				save_new_entry_to_temp_file "$entry" "${bookmark_locations[$entry]}"
			fi
		done

		save_bookmark_changes

		echo "$1 deleted!"

		echo ""
	}

	# Parse command line arguments first
	check_bookmark_existence

	confirmation_options=("Yes" "No")

	# Prompt user before deleting
	prompt_for_deletion() {
		echo "Are you sure you want to remove '$target_to_remove'?: "
		echo ""

		select opt in "${confirmation_options[@]}"; do
			case $opt in
			"Yes")
				delete_bookmark_from_file "$target_to_remove"
				break
				;;
			"No")
				echo ""
				echo "Deletion Cancelled"
				break
				;;
			*) echo "Please Select a valid option" ;;
			esac
		done
	}

	# When called with an argument, just confirm
	if [ -n "$target_to_remove" ]; then
		# If the argument provided is valid
		if [ $valid_bookmark -eq 1 ]; then
			prompt_for_deletion "$target_to_remove"
		else
			echo "Bad bookmark name"
			echo ""
			echo "Valid entries are:"
			for i in "${bookmark_options[@]}"; do
				echo "- $i"
			done
			echo ""
		fi

		#When called w/o argument, give user a menu
	else
		echo "Select a bookmark to Remove:"
		echo ""

		PS3="Your selection: "

		# Let me out
		bookmark_options+=("Quit")

		# Main Menu
		select opt in "${bookmark_options[@]}"; do
			case $opt in
			# Check this first!
			"Quit")
				break
				;;
			"$opt")
				target_to_remove="$opt"

				echo ""

				# Get confirmation from user
				prompt_for_deletion "$opt"

				break
				;;
			*) echo "Please select a vlid option" ;;
			esac
		done
	fi
}
