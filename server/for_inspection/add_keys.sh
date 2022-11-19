#!/bin/bash
for user in `seq -f "user%02g" 0 9`
do
        home=/home/$user
        for i in `seq -w 6 10`
        do
                ssh-keygen -t ecdsa -b 521 -C $user -N zsetrfgb -f $home/.ssh/id_ecdsa_$i
                cat $home/.ssh/id_ecdsa_$i.pub >> $home/.ssh/authorized_keys
        done
done
