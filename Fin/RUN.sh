#!/bin/bash

#Find all .sh files in current dir/sub dirs, and run them
#All .sh files in dir and sub dirs
SH_FILES="$(ls $(dirname $(readlink -f "${BASH_SOURCE[0]}")) | grep "[.]sh$" | grep -v "RUN[.]sh$")"
#chmod all files
for FILE in $SH_FILES; do
chmod 744 "$FILE"
#execute
echo "Running $FILE"
sudo $FILE
done
