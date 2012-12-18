#!/usr/bin/env bash

if [ "${#}" = "0" ]
then
    echo "Backup virtual machine from remote XenServer over SSH"
    echo "usage:" 
    echo "${0} [vm name] [ssh user host] [ssh pem key]"
    exit
fi

# $1 remote command
remote_exec() {
    chmod 0600 $PEMKEY
    ssh -i $PEMKEY -o "StrictHostKeyChecking no" $USERHOST $1
}

VMNAME=${1}
USERHOST=${2}
PEMKEY=${3}

# create snapshot
TIMESTAMP=`date '+%Y%m%d-%H%M%S'`
SNAPNAME="$VMNAME-$TIMESTAMP"
SNAPUUID=$(remote_exec "xe vm-snapshot vm=\"$VMNAME\" new-name-label=\"$SNAPNAME\"")

# export snapshot
remote_exec "xe snapshot-export-to-template snapshot-uuid=$SNAPUUID filename= | gzip" | gunzip | dd of="$SNAPNAME.xva"

# destroy snapshot
remote_exec "xe snapshot-uninstall force=true snapshot-uuid=$SNAPUUID"

echo "Snapshot of $VMNAME saved to $SNAPNAME.xva"
