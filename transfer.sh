#!/usr/bin/env bash


##  Please note - This script has not been tested yet because I dont have access to server
## dependencies - requires sshpass
host1=$1
host2=$2
user=$3
passwd=$4
file=$5
remoter_dir=$6


if sshpass -p $passwd scp -o stricthostkeychecking=no $file $user@$host1:$remoter_dir >&/dev/null ; then echo "transfer OK" ; else echo "transfer failed" ; fi
if sshpass -p $passwd scp -o stricthostkeychecking=no $file $user@$host2:$remoter_dir >&/dev/null ; then echo "transfer OK" ; else echo "transfer failed" ; fi
