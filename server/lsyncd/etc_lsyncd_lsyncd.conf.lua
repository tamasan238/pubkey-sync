settings{
    statusFile = "/var/run/lsyncd.pid",
    statusInterval = 1,
}

sync{
    default.rsync,
    source="/root/lsync/pubkeys/",
    excludeFrom="/etc/rsync_exclude.lst",
    target='host.hi17iwai.com::key',
    rsync = {
        links = false,
        copy_links = true
    }
}
