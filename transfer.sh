#!/usr/bin/env bash



## dependencies - please install sshpass on targer server - apt-get install sshpass
host1=$1
host2=$2
user=$3
passwd=$4
file=$5
remoter_dir=$6


if sudo sshpass -p $passwd scp -o stricthostkeychecking=no $file $user@$host1:$remoter_dir >&/dev/null ; then echo "transfer OK" ; else echo "transfer failed" ; fi
if sudo sshpass -p $passwd scp -o stricthostkeychecking=no $file $user@$host2:$remoter_dir >&/dev/null ; then echo "transfer OK" ; else echo "transfer failed" ; fi
