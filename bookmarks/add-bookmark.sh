#! /bin/bash

# TODO: allow adding multiple folders at once
# TODO: add prompt for multiple folders at once, while still running app

add_bookmark() {
	echo ""
	echo "+--------------+"
	echo "| Add Bookmark |"
	echo "+--------------+"
	echo ""

	name=""

	# Parse Command Line args
	while getopts "d:" opt; do
		case $opt in
		d)
			add_args_received=1
			target_folder="$OPTARG"
			break
			;;
		*)
			add_args_received=0
			target_folder=""
			echo "THERE's BEEN AN ERROR!"
			break
			;;
		esac
	done

	# Initialize or Load bookmarks
	if [ -f "$HOME/bin/bookmarks/bookmarks.txt" ]; then
		bookmark_file="$HOME/bin/bookmarks/bookmarks.txt"
	else
		touch "$HOME/bin/bookmarks/bookmarks.txt"
		bookmark_file="$HOME/bin/bookmarks/bookmarks.txt"

		echo "Bookmarks File Created"
	fi

	# Check all bookmark names
	check_duplicate_bookmark_name() {
		# Set up condition
		is_valid_name=0

		while read -r p; do
			bm_name=$(echo "$p" | cut -d ',' -f 1 | cut -d '[' -f 2)

			if [ "$bm_name" = "$name" ]; then
				echo "Bookmark with that name already exists!"
				is_valid_name=1
			fi
		done <"$bookmark_file"

	}

	# Check all bookmarked locations
	check_duplicate_location() {
		# Set up condition
		is_valid_directory=0

		while read -r p; do
			bm_location=$(echo "$p" | cut -d ',' -f 2 | cut -d ']' -f 1)

			if [ "$bm_location" = "$target_folder" ]; then
				echo "Bookmark with that location already exists!"
				is_valid_directory=1
			fi

		done <"$bookmark_file"
	}

	# Menu for naming bookmark
	get_name() {
		check_duplicate_location
		if [[ "$is_valid_directory" -eq 0 ]]; then
			echo "The target directory is $target_folder"
			echo ""

			local PS3="Enter bookmark name below (type -q to cancel): "
			echo "$PS3"

			# While empty and has a zero length
			while [ "$name" = "" ] && [ -z "$name" ]; do
				read -r name
			done

			check_duplicate_bookmark_name

			if [ "$name" != "-q" ]; then
				if [[ "$is_valid_name" -eq 0 ]]; then
					echo "Adding bookmark '$name' with location '$target_folder'"
					echo "[$name,$target_folder]" >>"$bookmark_file"
				fi
			fi
		fi
	}

	check_duplicate_location
	options_add_current=()

	PS3="Your selection: "

	# Only when passed into the function call
	if [[ "$add_args_received" -eq 1 ]]; then
		options_add_current+=("Add $target_folder to bookmarks")
	else
		options_add_current+=("Add current folder to bookmarks")
	fi

	options_add_current+=("Quit")

	if [ "$is_valid_directory" -eq 0 ]; then
		echo "Adding Bookmark $target_folder"
		echo ""

		# Main Menu
		select opt in "${options_add_current[@]}"; do
			case $opt in
			"Add current folder to bookmarks")
				get_name
				break
				;;
			"Add $target_folder to bookmarks")
				get_name
				break
				;;
			"Quit")
				break
				;;
			*)
				echo "Bad Selection"
				;;
			esac
		done
	# else
	# 	echo "A bookmark with that name already exists!"
	fi
}
