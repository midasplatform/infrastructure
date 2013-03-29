#!/bin/bash

sudo apt-get update

sudo apt-get -y install ruby

wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb
sudo apt-get update
sudo apt-get -y install puppet

sudo apt-get -y install git-core

puppet module install puppetlabs/apache
puppet module install puppetlabs/mysql
mkdir local_puppet_modules
git clone git://github.com/midasplatform/midas-puppet.git local_puppet_modules/midas

git clone git://github.com/midasplatform/infrastructure.git
