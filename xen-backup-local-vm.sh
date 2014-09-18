#!/usr/bin/env bash

if [ "${#}" = "0" ]
then
    echo "Backup virtual machine from local XenServer"
    echo "usage:" 
    echo "${0} [vm name]"
    exit
fi

VMNAME=${1}

# create snapshot
TIMESTAMP=`date '+%Y%m%d-%H%M%S'`
SNAPNAME="$VMNAME-$TIMESTAMP"
SNAPUUID=$(xe vm-snapshot vm="$VMNAME" new-name-label="$SNAPNAME")

# export snapshot
xe snapshot-export-to-template snapshot-uuid=$SNAPUUID filename="$SNAPNAME.xva"

# destroy snapshot
xe snapshot-uninstall force=true snapshot-uuid=$SNAPUUID

echo "Snapshot of $VMNAME saved to $SNAPNAME.xva"
