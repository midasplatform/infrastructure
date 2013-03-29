#!/bin/bash

cd ~/local_puppet_modules/midas
git pull
cd ~/
sudo puppet apply --modulepath /home/ubuntu/.puppet/modules:/home/ubuntu/local_puppet_modules infrastructure/vagrant/puppet/vagrant-manifests/instance.pp
