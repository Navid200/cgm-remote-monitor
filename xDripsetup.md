#!/bin/bash

dialog --colors --msgbox "     \Zr Developed by the xDrip team \Zn\n\n\
You will see a QR code.  You can scan with xDrip to make it master.  But, please note that if your xDrip is already uploading \
to a Nightscout, scanning the QR code will siable that.  If you intend to upload to both, you need to add the URL manually as \
explained in the guide." 16 50

pass=$(cat /etc/nsconfig | grep API_SECRET)
echo "pass"

#qrencode -m 6 -t utf8 <<< '{"rest":{"endpoint":["https://S3pt3mb3r032022!@https://iea.chickenkiller.com/api/v1"]}}'

#qrencode -m 6 -t utf8 <<< '{"rest":{"endpoint":["https://aaaaaaaaaaaaa@aa.avv.rrtt/api/v1"]}}'
