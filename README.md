# My Virtual Testlab

## What is this

This is a vagrant environment that allows one to easily start a few servers, network them and provision them with puppet.

## Prerequisites

What you will need:

- Vagrant 
- Vagrant plugins
  - vagrant-cachier
  - vagrant-hostmanager
  - vagrant-proxyconf
  - vagrant-puppet-install
  - vagrant-share
  - vagrant-vbguest
- Puppet-librarian

And of course you will need ruby.

## Installation

### Install VirtualBox

[Get it here](http://virtualbox.org)
### Install RVM and ruby

See [nstallation instructions here.](https://rvm.io/rvm/install)

Afterwards I added this to my .profile:

```
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```

Then install ruby 2.1.1 with `rmv install 2.1.1`

### Install Vagrant

Vagrant has installers for different platforms. You can get those [here](http://www.vagrantup.com/downloads)

Once vagrant is installed install all the plugins listed above using `vagrant plugin install <plugin>`
### Install libarian-puppet

Given that you have ruby and rubygems available you can just do the following:

`$ gem install librarian-puppet`

## How to use this

Make a clone of this repository. In this version I have defined three nodes, one is a Jenkins CI node, one runs docker, and the last one is a pulp server. 
If you want to add your own servers you just need to add them to servers.yaml
You normally don't need to touch the Vagrantfile.
When you run `vagrant up` the machines are created. The plug ins make sure that the virtual box guest additions are up to date, and that puppet is installed. They also add the names and IPs of all the other running boxes to `/etc/hosts` so that they can talk to each other. 
Then the machines are provisioned using puppet and hiera. There is a site.pp in `puppet/manifests`, and in hieradata you can set defaults for your systems, and separate node files for each node where you can assign classes, and resources.
The puppet modules needed will be installed in `puppet/modules`. You can install them like this:

```
$ cd puppet/modules
$ librarian-puppet install --path=.
```

If you need more modules add them to the Puppetfile and run librarian-puppet again.

Then run `vargrant up` and all your servers should be started and provisioned. Enjoy!
