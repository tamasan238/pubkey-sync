#!/bin/bash

# config
home_path=/home
key_path=/root/lsync/pubkeys
start_line=###_BEGIN_AUTO_EDIT_AREA_###
end_line=###_END_AUTO_EDIT_AREA_###

# distribute pubkeys for user's home directory
for username in `ls $home_path`
do
        if [ -e $key_path/$username.pub  ]
        then
            auth_path=$home_path/$username/.ssh/authorized_keys

            # delete old pubkeys
            begin=`grep -n $start_line $auth_path | awk -F ':' '{print $1}'`
            if [ $begin > 0 ]
            then
                end=`grep -n $end_line $auth_path | awk -F ':' '{print $1}'`
                sed ''$begin','$end'd' $auth_path > ${auth_path}_tmp
                mv ${auth_path}_tmp $auth_path
                chown $username $auth_path
                chmod 600 $auth_path
            fi

            # add new pubkeys
            echo $start_line >> $auth_path
            cat $key_path/$username.pub >> $auth_path
            echo $end_line >> $auth_path
        fi
done

