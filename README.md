# midasplatform/infrastructure


This repository will house tools used to automate deployment, configuration, and management of midas instances and ecologies.





----
## Installing Midas on a Virtualbox VM with Vagrant and Puppet


see the [wiki article](https://github.com/midasplatform/infrastructure/wiki/Testing-the-Puppet-manifest-locally-with-Vagrant)

----
## Installing Midas on an AWS EC2 Ubuntu instance with Puppet


see the [wiki article](https://github.com/midasplatform/infrastructure/wiki/AWS)

----
## Ubuntu 12.04 server midas install with Puppet

Assuming you already have an OS booted.

There are two bash scripts included in this repo.

`bootstrap.sh` will take an Ubuntu machine and add in the requirements in order to run puppet.

It will add in some package dependencies to get git and the right version of puppet, then will checkout this repository and the @midasplatform/midas-puppet repository.

`provision.sh` will run Puppet on the `instance.pp` manifest to make the server have the `midas` root as the server's docroot, and will make the server an ssl only webserver (port 80 is open but will redirect to 443).  It expects that `bootstrap.sh` has been run previously.


Issues with this method:

* `bootstrap.sh` installs this repository @midasplatform/infrastructure on the box, but `bootstrap.sh` is a part of this repository.  So `bootstrap.sh` must be copied onto the box.
* It would be much better to have a clean image or ami that includes what `bootstrap.sh` accomplishes.




