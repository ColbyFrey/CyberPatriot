#!/bin/bash
#**Searches for all files in dir that contain keywords in discription**#
#Temp storage to allow parrallel process
TEMP=$(mktemp)
#Process $1 (1st var
if [ -n "$1" ]; then #Checks for valid input [ -d "$1" ] &&
	#Find all file types under $DIR with media descriptions
	find "$1" -type f > $TEMP && cat $TEMP | xargs file | grep -i "[ ]media\|[ ]audio\|[ ]video\|[ ]picture\|[ ]image\|[ ]recording"
	#Remove file containing files searched
	rm $TEMP
	echo $TEMP
	echo $1
#elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then #Checks if asked for help
#	printf "Usage: MediaSearch \$dir\n"
#	printf "\tSearches all files in, and in sudirectories of \$dir\n"
#	printf "\tNOTE: Directories containing more files will take longer\n"
#	printf "\tNOTE: Some directories require root to access\n"
#elif ! [ -d "$1" ] && [ -n "$1" ]#; then #Checks if $1 is a dir
#	printf "\"$1\" DIRECTORY NOT FOUND\n"
#	printf "Try "-h" or "--help" for more info\n"
else
	printf "Usage: MediaSearch DIR\n"
	printf "Try 'advTextEdit --help' for more information\n"
fi
