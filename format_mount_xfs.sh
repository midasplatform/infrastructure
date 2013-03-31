#!/bin/bash

device=$1
mountdir=$2

#install xfs
sudo apt-get install -y xfsprogs
sudo grep -q xfs /proc/filesystems || sudo modprobe xfs

#format the volume
sudo mkfs.xfs $device

#mount the volume, set it to not automount
echo "$device $mountdir xfs noauto,noatime 0 0" | sudo tee -a /etc/fstab
sudo mkdir -m 000 $mountdir
sudo mount $mountdir

