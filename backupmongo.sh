#!/bin/bash

cat > /tmp/samefilename << EOF
A file with the same name exists.
Use a different filename.

EOF

while :
do
exec 3>&1
Filename=$(dialog --ok-label "Submit" --form "Enter a name for the backup file" 12 50 0 "file name" 1 1 "$filename" 1 14 25 0 2>&1 1>&3) 
 response=$?
if [ ! $response = 255 ] & [ ! $response = 1 ]
then
if [ -s $Filename ]
then
dialog --textbox /tmp/samefilename 10 50
else
mongodump --gzip --archive=$Filename 
exec 3>&- 
fi
fi
done
