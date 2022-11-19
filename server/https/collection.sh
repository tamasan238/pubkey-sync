#!/bin/bash

home_path=/home

# delete old files
rm /var/www/html/*.pub

for username in `ls $home_path`
do
        # check public/private (black list)
        isPublic=true
        for private_user in `cat /root/private_user.txt`
        do
                if [ $username == $private_user ]
                then
                        isPublic=false
                fi
        done

        # generate list of public user
        if "${isPublic}"
        then
                echo $username >> /root/userlist.txt
        fi
done

# publish user's pubkey
for public_user in `cat /root/userlist.txt`
do
        raw_path=$home_path/$public_user/.ssh/authorized_keys
        if [ ! -e $raw_path ]
        then
            continue # not found
        fi
        cp $raw_path /var/www/html/$public_user.pub
        chmod 444 /var/www/html/$public_user.pub
done

# delete temp file
rm /root/userlist.txt

