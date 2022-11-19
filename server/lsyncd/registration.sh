#!/bin/bash

# append host for allow list (lsyncd)
echo ""
echo " Input new sync target."
echo "  ex) host.example.com::key"
read target

config=/etc/lsyncd/lsyncd.conf.lua
cat <<EOL >> $config
sync{
    default.rsync,
    source="/root/lsync/pubkeys/",
    excludeFrom="/etc/rsync_exclude.lst",
    target='${target}',
    rsync = {
        links = false,
        copy_links = true
    }
}
EOL

systemctl restart lsyncd
echo "That host was appended for target list."
