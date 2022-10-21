#!/bin/bash

File=$(dialog --title "Select the backup file to restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)

key=$?

if [ $key = 255 ] || [ $key = 1 ]
then
clear
exit
fi

echo "$File"
mongorestore --gzip --archive=$File
 
