#!/bin/bash

cat > /tmp/restore_note << EOF
Error
You need to move the cursor over the filename
in the right pane and press space so that it
is shown in the field at the bottom.
Then, move the cursor over OK and press enter.

EOF

while :
do
File=$(dialog --title "Select the backup file to restore" --fselect ~/ 10 50 3>&1 1>&2 2>&3)

key=$?

if [ $key = 255 ] || [ $key = 1 ]
then
clear
exit
fi

echo "$File"
mongorestore --gzip --archive=$File
fail=$?
if [ $fail = 1 ]
then
dialog --textbox /tmp/restore_note 10 50
else
clear
exit
fi

done
 
