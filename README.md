# midasplatform/infrastructure


This repository will house tools used to automate deployment, configuration, and management of midas instances and ecologies.

Currently it only has a Puppet script used on Ubuntu 12.04 to set up a Midas instance, but in the future it might have bells and whistles aplenty.

----
## Ubuntu 12.04 server midas install with Puppet
1. Install Ruby (v 1.8.7)

        sudo apt-get install ruby

2. puppet from apt-get is 2.7.11, get the package from puppetlabs which is at least 3.1.1
        
        wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
        sudo dpkg -i puppetlabs-release-precise.deb
        sudo apt-get update
        sudo apt-get install puppet

3. install two puppet modules
        
        sudo puppet module install puppetlabs/apache
        sudo puppet module install puppetlabs/mysql

4. apply the midas puppet script    
        
        sudo puppet apply midas.pp

