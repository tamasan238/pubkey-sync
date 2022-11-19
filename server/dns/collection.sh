#!/bin/bash

home_path=/home
fqdn=key.hi17iwai.com

echo "" > /root/dns/userlist.txt
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
            echo $username >> /root/dns/userlist.txt
    fi
done

# delete old data
gcloud dns record-sets transaction start -z=default
for dns_name in `gcloud dns record-sets list -z=default --filter="name ~ .pubkey.$fqdn.$" | awk '{print $1}' | sed -e '1d'`
do
    gcloud dns record-sets delete $dns_name --type=TXT -z=default
done
gcloud dns record-sets transaction execute -z=default

# publish user's pubkey
gcloud dns record-sets transaction start -z=default
for username in `cat /root/dns/userlist.txt`
do
    raw_path=$home_path/$username/.ssh/authorized_keys
    if [ ! -e $raw_path ]
    then
        continue; # not found
    fi

    # escape newline character
    sed -z 's/\n/^/g' $raw_path > ${raw_path}_escaped

    # split authorized_keys
    split -b 255 -d ${raw_path}_escaped $raw_path.part.

    # set records
    for split_file in `ls $raw_path.part.*`
    do
        no=${split_file: -2}
        record=`cat $split_file`
        gcloud dns record-sets transaction add -z=default --name="$no.$username.pubkey.$fqdn." --type TXT --ttl=300 "$record"
    done

    # last record number
    gcloud dns record-sets transaction add -z=default --name="$username.pubkey.$fqdn." --type TXT --ttl=300 "$no"

    # delete old files
    rm ${raw_path}_escaped
    rm $raw_path.part.*
done

gcloud dns record-sets transaction execute -z=default

#gcloud dns record-sets list --zone=default

