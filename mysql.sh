#!/bin/bash

# taken from http://aws.amazon.com/articles/1663
# this is based on getting an EBS in the same availability region as the ec2 instance
# after attaching the EBS to the ec2, it won't show up in df -h, but you can see it in sudo fdisk -l
# it isn't mounted

# need the name of the device here
# if you requested /dev/sds it will show up as /dev/xvds
#device='/dev/xvds'


#install xfs
#sudo apt-get install -y xfsprogs
#sudo grep -q xfs /proc/filesystems || sudo modprobe xfs

#format the volume
#sudo mkfs.xfs $device

#mount the volume, set it to automount
#echo "$device /vol xfs noatime 0 0" | sudo tee -a /etc/fstab
#sudo mkdir -m 000 /vol
#sudo mount /vol

# stop mysql server
#sudo /etc/init.d/mysql stop

#move existing db files to ebs volume
#sudo mkdir /vol/etc /vol/lib /vol/log
#sudo mv /etc/mysql /vol/etc
#sudo mv /var/lib/mysql /vol/lib
#sudo mv /var/log/mysql /vol/log

#sudo mkdir /etc/mysql
#sudo mkdir /var/lib/mysql
#sudo mkdir /var/log/mysql

#echo "/vol/etc/mysql /etc/mysql    none bind" | sudo tee -a /etc/fstab
#sudo mount /etc/mysql

#echo "/vol/lib/mysql /var/lib/mysql    none bind" | sudo tee -a /etc/fstab
#sudo mount /var/lib/mysql

#echo "/vol/log/mysql /var/log/mysql    none bind" | sudo tee -a /etc/fstab
#sudo mount /var/log/mysql

# restart mysql server
#sudo /etc/init.d/mysql start
