#!/bin/bash

home_path=/home
lines_now=`wc /etc/passwd | awk '{print $1}'`
lines_old=`cat /root/lsync/etc_passwd_wc`

lines_diff=`expr $lines_now - $lines_old`
if [ $lines_diff > 0 ]
then
        new_users=`sed -n ''$lines_old','$lines_now'p' /etc/passwd | awk -F ':' '{print $1}'`
        for user in $new_users
        do
                ln -s $home_path/$user/.ssh/authorized_keys /root/lsync/pubkeys/$user.pub
        done
        wc /etc/passwd | awk '{print $1}' > /root/lsync/etc_passwd_wc
fi
