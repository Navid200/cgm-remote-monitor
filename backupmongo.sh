#!/bin/bash

cat > /tmp/samefilename << EOF
A file with the same name exists.
Choose a different filename.

EOF

cat > /tmp/download_note << EOF
The backup is complete.  
However, it is on the same virtual machine as
your MongoDB.
It's best to download the file to your computer
for safekeeping.

EOF

while :
do
exec 3>&1
Filename=$(dialog --ok-label "Submit" --form "Enter a name for the backup file" 8 50 0 "file name" 1 1 "$filename" 1 14 25 0 2>&1 1>&3)
 response=$?
if [ $response = 255 ] || [ $response = 1 ]
then
clear
exit
fi

if [ -s $Filename ]
then
dialog --exit-label "Try again" --textbox /tmp/samefilename 7 50
else
mongodump --gzip --archive=$Filename
exec 3>&-
dialog --textbox /tmp/download_note 8 50
clear
exit
fi
done
 
