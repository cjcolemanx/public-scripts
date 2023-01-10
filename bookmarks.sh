#! /bin/bash

bookmarks() {
	help_function() {
		echo ""
		echo "usage: bookmarks [PARAMS] .. [BOOKMARK_DIR|BOOKMARK_NAME]"
		echo -e "\t-A Add a bookmark at with [BOOKMARK_DIR] path"
		echo -e "\t-a Add a bookmark at the current directory"
		echo -e "\t-B Go to [BOOKMARK_NAME] (WIP)"
		echo -e "\t-R Remove a bookmark with [BOOKMARK_NAME]"
		echo -e "\t-r Remove a bookmark via select"
		echo -e "\t-l List all stored bookmark"
		echo ""
	}

	print_title() {
		echo ""
		echo " ~ Bookmarks ~"
	}
	option_selected="DEFAULT"

	while getopts "haA:B:R:rl" opt; do
		case $opt in
		A)
			option_selected="ADD"
			add_options="$OPTARG"
			break
			;;
		a)
			option_selected="ADD"
			add_options=""
			break
			;;
		B)
			option_selected="GOTO"
			goto_options="$OPTARG"
			break
			;;
		R)
			option_selected="REMOVE"
			remove_options="$OPTARG"
			break
			;;
		r)
			option_selected="REMOVE"
			remove_options=""
			break
			;;
		l)
			option_selected="LIST"
			break
			;;
		h)
			option_selected="HELP"
			help_function
			;;
		*)
			help_function
			;;
		esac
	done

	# Ensure bookmark file exists
	if [ -f "$HOME/bin/bookmarks/bookmarks.txt" ]; then
		bookmarks_file="$HOME/bin/bookmarks/bookmarks.txt"
	else
		touch "$HOME/bin/bookmarks/bookmarks.txt"
		bookmarks_file="$HOME/bin/bookmarks/bookmarks.txt"
		echo "Bookmarks File Created"
	fi

	if [ -n "$option_selected" ]; then
		# Call the bookmark adding script
		if [[ "$option_selected" = "ADD" ]]; then
			print_title

			source "$HOME/bin/bookmarks/add-bookmark.sh"

			# If a path argument was passed with the '-A' option
			if [ -n "$add_options" ]; then
				add_bookmark -d "$add_options"
			else
				temp_bookmark_dir=$(pwd)
				add_bookmark -d "$temp_bookmark_dir"
			fi

			# Call the bookmark removing script
		elif [ "$option_selected" = "REMOVE" ]; then
			print_title

			source "$HOME/bin/bookmarks/remove-bookmark.sh"

			# If a path argument was passed with the '-A' option
			if [ -n "$remove_options" ]; then
				remove_bookmark -B "$remove_options"
			else
				remove_bookmark
			fi

			# Prompt user, then call the bookmark listing script
		elif [ "$option_selected" = "LIST" ]; then
			print_title

			source "$HOME/bin/bookmarks/list-bookmarks.sh"

			list_options=("All" "Just the names" "Just the locations" "Cancel")
			PS3="What would you like to display?: "

			select opt in "${list_options[@]}"; do
				case $opt in
				"All")
					list_bookmarks -t "all"
					break
					;;
				"Just the names")
					list_bookmarks -t "bookmark_names"
					break
					;;
				"Just the locations")
					list_bookmarks -t "bookmark_locations"
					break
					;;
				"Cancel")
					break
					;;
				*) echo "Please enter a valid option." ;;
				esac
			done

			# Go to an existing bookmark
		elif [ "$option_selected" = "GOTO" ]; then
			source "$HOME/bin/bookmarks/goto-bookmark.sh"

			goto_bookmark "$goto_options"

			# List bookmarks for user to select
		elif [[ "$option_selected" = "DEFAULT" ]]; then
			print_title
			echo ""
			echo "+-------------------+"
			echo "| Bookmarks Manager |"
			echo "+-------------------+"
			echo ""

			selection_is_valid=false
			PS3='Select a Bookmark: '

			declare -A bookmark_locations
			bookmark_options=("Home")

			# Get All Options
			while read -r p; do
				bm_location=$(echo "$p" | cut -d ',' -f 2 | cut -d ']' -f 1)
				bm_name=$(echo "$p" | cut -d ',' -f 1 | cut -d '[' -f 2)
				bookmark_options+=("$bm_name")
				bookmark_locations+=([$bm_name]="$bm_location")
			done <"$bookmarks_file"

			### Defaults
			bookmark_options+=("Sys Log")
			bookmark_options+=("Sys Bin")
			bookmark_options+=("Quit")

			selected=$(pwd)

			# Validates Selection
			check_option() {
				for item in "${bookmark_options[@]}"; do
					if [[ "$1" == "$item" ]]; then
						selected="${bookmark_locations[$1]}"
						selection_is_valid=true
					fi
				done
			}

			# Menu
			select opt in "${bookmark_options[@]}"; do
				case $opt in
				# "Home")
				# 	selected="$HOME"
				# 	break
				# 	;;
				"Sys Log")
					selected="/var/log"
					break
					;;
				"Sys Bin Files")
					selected="/bin"
					break
					;;
				"Quit")
					break
					;;
				*)
					check_option "$opt"

					if $selection_is_valid; then
						break
					else
						echo "Please enter a valid option."
						echo ""
						echo "$PS3"
					fi
					;;
				esac
			done

			user_cd_msg_dir="$selected"

			if [[ "$selected" == *"$HOME"* ]]; then
				home_string_substitute="~"
				user_cd_msg_dir="${selected/"$HOME"/"$home_string_substitute"}"
			fi

			echo ""
			echo "Changing directory to $user_cd_msg_dir"

			cd "$selected" || exit
		fi
	fi

	# Give some Space
	echo ""
}
