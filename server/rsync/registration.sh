#!/bin/bash

# append host for allow list (nginx)
echo ""
echo " Input new host's IP address."
echo "  ex) 35.233.143.242"
read ip

config=/etc/rsyncd.conf
sed -i -e "s/127.0.0.1/$ip 127.0.0.1/" $config
systemctl restart rsync
echo "That IP address was appended for allow list."
