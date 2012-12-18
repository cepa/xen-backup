#!/usr/bin/env bash

if [ "${#}" = "0" ]
then
    echo "Backup all virtual machines from remote XenServer over SSH"
    echo "usage:" 
    echo "${0} [ssh user host] [ssh pem key]"
    exit
fi

# $1 remote command
remote_exec() {
    chmod 0600 $PEMKEY
    ssh -i $PEMKEY -o "StrictHostKeyChecking no" $USERHOST $1
}

SCRIPTDIR=$(cd ${0%/*}; pwd)

USERHOST=${1}
PEMKEY=${2}

# get list of all VM
VMNAMES=$(remote_exec "xe vm-list is-control-domain=false | grep name-label | cut -d ':' -f 2 | tr -d ' '")
for VMNAME in $VMNAMES
do
    echo "Backup $VMNAME"
    time $SCRIPTDIR/xen-backup-vm.sh $VMNAME $USERHOST $PEMKEY
done
