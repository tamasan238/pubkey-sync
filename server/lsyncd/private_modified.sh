#!/bin/bash

sed -e 's*^*/root/lsync/pubkeys/*g' -e 's*$*.pub*g' /root/private_user.txt > /etc/rsync_exclude.lst
systemctl restart lsyncd
systemctl restart rsync
