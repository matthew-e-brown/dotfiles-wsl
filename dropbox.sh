#!/usr/bin/env bash

# For WSL, there are only a few things I care about on Dropbox.
# Easiest just to hardcode them.
declare -a paths=(
	"Coursework/5th Year - 2022-2023/Winter/COIS-4350H High Performance Computing"
	# "Coursework/5th Year - 2022-2023/Winter/COIS-3320H Fundamentals of Operating Systems"
)


if [[ "$1" = "up" || "$1" = "down" ]]
then
	action="sync"
	direction="$1"
	shift
elif [[ "$1" = "bisync" ]]
then
	action="bisync"
	direction="down"
	shift
else
	>&2 echo "Requires subcommand; 'up', 'down', or 'bisync'"
	exit 1
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

	# Pass remaining options like --dry-run or --verbose to rclone
	rclone $action "$src" "$dst" "$@" || break
done
