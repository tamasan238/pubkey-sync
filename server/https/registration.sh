#!/bin/bash

# append host for allow list (nginx)
echo ""
echo " Input new host's IP address."
echo "  ex) 35.233.143.242"
read ip

config=/etc/nginx/sites-enabled/default
sed -i -e "/        deny all;$/i allow $ip;" $config
systemctl reload nginx
echo "That IP address was appended for allow list."

# print SSHFP records (don't have to)
echo ""
echo " Input new host's port of SSH."
echo "  ex) 55122"
read port

echo ""
echo " @@ These are SSHFP records for DNS. @@"
echo ""
ssh-keyscan -D -p $port $ip

