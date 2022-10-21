#!/bin/bash

cat > /tmp/samefilename << EOF
A file with the same name exists.
Choose a different filename.

EOF



File=$(dialog --title "Select the backup file to restore" --fselect /home 14 50)

if [ $response = 255 ] || [ $response = 1 ]
then
clear
exit
fi

 
