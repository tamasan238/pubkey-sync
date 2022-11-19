#!/bin/bash
for user in `seq -f "user%02g" 0 99`
do
	useradd -m $user -p $(perl -e 'print crypt("zsetrfgb", "\$6\$salt03")')
	home=/home/$user
	
	mkdir -m 700 $home/.ssh
	touch $home/.ssh/authorized_keys
	chmod 600 $home/.ssh/authorized_keys
	
	for i in `seq -w 5`
	do
		ssh-keygen -t ecdsa -b 521 -C $user -N zsetrfgb -f $home/.ssh/id_ecdsa_$i
		cat $home/.ssh/id_ecdsa_$i.pub >> $home/.ssh/authorized_keys
	done
	
	chown $user:$user -R $home/.ssh
done
