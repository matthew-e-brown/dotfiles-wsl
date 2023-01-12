#!/usr/bin/env bash

# For WSL, there are only a few things I care about on Dropbox.
# Easiest just to hardcode them.
declare -a paths=(
	"Coursework/5th Year - 2022-2023/Winter/COIS-4350H High Performance Computing"
	"Coursework/5th Year - 2022-2023/Winter/COIS-3320H Fundamentals of Operating Systems"
)


if [[ -z "$1" || ( "$1" != "sync" && "$1" != "bisync" ) ]]
then
	>&2 echo "$0 requires subcommand 'sync' or 'bisync'"
	exit 1
else
	action="$1"
	shift
fi


if [[ "$action" = "sync" ]]
then
	if [[ "$1" = "up" || "$1" = "down" ]]
	then
		direction="$1"
		shift
	else
		>&2 echo "'sync' subcommand requires direction, 'up' or 'down'"
		exit 1
	fi
fi


for path in "${paths[@]}"
do
	local_path="${HOME}/Dropbox/$path"
	remote_path="dropbox:/$path"

	if [[ "$direction" = "up" ]]
	then
		src="$local_path"
		dst="$remote_path"
	else
		src="$remote_path"
		dst="$local_path"
	fi

	# Path remaining options like --dry-run or --verbose to rclone
	rclone $action "$src" "$dst" "$@"
done
